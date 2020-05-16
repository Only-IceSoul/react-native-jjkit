package com.reactjjkit.photoKit

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.core.app.ActivityCompat
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.facebook.react.bridge.*
import java.io.ByteArrayOutputStream

class PhotoKitModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context)  {

   private val reactContext: ReactApplicationContext = context
    private val mListener = object : ActivityEventListener {
        override fun onNewIntent(intent: Intent?) {

        }

        override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {
            if(requestCode == 200 && resultCode == Activity.RESULT_OK){
                mPromise = if(mPromise != null && data != null) {
                    val status = data.getIntExtra("status", 0)
                    mPromise?.resolve(status)
                    null
                }else{
                    mPromise?.resolve(0)
                    null
                }
                reactContext.removeActivityEventListener(this)
            }
        }

    }

    override fun getName(): String {
        return "PhotoKit"
    }

    override fun getConstants(): MutableMap<String, Any> {
        return mutableMapOf(
                "image" to "image",
                "video" to "video",
                "video_photo" to "video_photo",
                "video_gif" to "video_gif",
                "gif" to "gif",
                "photo" to "photo",
                "all" to "all",
                "jpeg" to 0,
                "png" to 1)
    }


    @ReactMethod
    fun isPermissionGranted(promise: Promise){
        val bool =  ActivityCompat.checkSelfPermission(reactContext, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                &&  ActivityCompat.checkSelfPermission(reactContext, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
        promise.resolve(bool)
    }


    private var mPromise : Promise? = null
    @ReactMethod
    fun requestPermission(promise: Promise){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val i = Intent(reactContext, PermissionActivity::class.java)
            reactContext.addActivityEventListener(mListener)
            reactContext.startActivityForResult(i,200, Bundle())
            mPromise = promise
        }else{
            promise.resolve(1)
        }
    }


    @ReactMethod
    fun requestRaw(data:String?,promise: Promise){
       val bytes = reactContext.contentResolver.openInputStream(Uri.parse(data))?.readBytes()
        if (bytes != null && bytes.isNotEmpty()){
            val str = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
            promise.resolve(str)
        }else{
            promise.resolve(null)
        }
    }

    @ReactMethod
    fun requestImage(data:ReadableMap?,promise: Promise){
        val identifier = data?.getString("uri")
        val width = data?.getInt("width") ?: 500
        val height = data?.getInt("height") ?: 500
        val quality = data?.getDouble("quality") ?: 1.0
        val format = data?.getInt("format") ?: 0

        if(identifier!= null && identifier.isNotEmpty()){
            val options = RequestOptions().fitCenter().frame(0L).override(width,height)

            Glide.with(reactContext).asBitmap().load(identifier)
                    .apply(options)
                    .into(object: CustomTarget<Bitmap>(){
                override fun onLoadCleared(placeholder: Drawable?) {}
                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    val baos = ByteArrayOutputStream()
                    val q = (100 * quality).toInt()
                    if (format == 0){
                        if(resource.compress(Bitmap.CompressFormat.JPEG, q, baos)){
                            val bytes = baos.toByteArray()
                            val str = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
                            promise.resolve(str)
                        }else promise.resolve(null)
                    }else{
                        if(resource.compress(Bitmap.CompressFormat.PNG, q, baos)){
                            val bytes = baos.toByteArray()
                            val str = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
                            promise.resolve(str)
                        }else promise.resolve(null)
                    }
                }
            })
        }else{
            promise.resolve(null)
        }
    }



    @ReactMethod
    fun fetch(media:String?, promise: Promise)  {
        Thread {
            try{
                val galleryAlbums: ArrayList<MutableMap<String,Any>> = ArrayList()
                val galleryMedia: ArrayList<MutableMap<String,Any>> = ArrayList()
                val albumsNames: ArrayList<String> = ArrayList()

                when(media){
                    "image" -> {
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,null, null)
                    }
                    "video" -> {
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,null,null)
                    }
                    "photo" ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} != ?"
                        val arr = arrayOf(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select,arr)
                    }
                    "gif"->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} = ?"
                        val arr = arrayOf(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select,arr)
                    }
                    "video_gif"->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} = ?"
                        val arr = arrayOf(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select,arr)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,null,null)
                    }
                    "video_photo" ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} != ?"
                        val arr = arrayOf(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select,arr)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,null,null)
                    }
                    else -> {
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,null,null)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,null,null)
                    }
                }


                val resultAlbum = Arguments.createArray()
                val resultMedia = Arguments.createArray()
                for (a in galleryAlbums){
                    resultAlbum.pushMap(Arguments.makeNativeMap(a))
                }
                for (m in galleryMedia){
                    resultMedia.pushMap(Arguments.makeNativeMap(m))
                }
                val result = Arguments.createArray()
                result.pushArray(resultAlbum)
                result.pushArray(resultMedia)
                Handler(Looper.getMainLooper()).post {
                    promise.resolve(result)
                }

            }catch ( e: Exception){
                Log.e("PhotoKit", "fetchPhotos:error $e")
                Handler(Looper.getMainLooper()).post {
                    promise.reject(e)
                }

            }
            Thread.currentThread().interrupt()
        }.start()
    }
    @ReactMethod
    fun fetchAlbums(names:ReadableArray?, media: String?,promise: Promise)  {
        if(names == null || names.size() < 1) {
            promise.resolve(null)
            return
        }
            Thread {
                try{
                    var select = ""
                    val selectArgs = mutableListOf<String>()

                    for (i in 0 until names.size()){
                        val s = names.getString(i)
                        if(!s.isNullOrEmpty()) {
                            selectArgs.add(s)
                        }
                    }

                    if (selectArgs.size > 1){
                        selectArgs.forEachIndexed { index, _ ->
                            select += if (index != selectArgs.size - 1)
                                "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ? OR "
                            else
                                "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ?"
                        }
                    }else if (selectArgs.size > 0){
                        select = "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ?"
                    }

                    if (select.isEmpty()) {
                        promise.resolve(null)
                    }else{
                        val galleryAlbums: ArrayList<MutableMap<String,Any>> = ArrayList()
                        val galleryMedia: ArrayList<MutableMap<String,Any>> = ArrayList()
                        val albumsNames: ArrayList<String> = ArrayList()
                        val sArgs = selectArgs.toTypedArray()
                        when (media) {
                            "image" -> {
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select, sArgs)
                            }
                            "video" -> {
                                getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,select,sArgs)
                            }
                            "gif" ->{
                                val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                                val selectMod = "$select AND ${MediaStore.Images.Media.MIME_TYPE} = ?"
                                selectArgs.add(mimeType)
                                val arr = selectArgs.toTypedArray()
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,selectMod, arr)
                            }
                            "photo" -> {
                                val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                                val selectMod = "$select AND ${MediaStore.Images.Media.MIME_TYPE} != ?"
                                selectArgs.add(mimeType)
                                val arr = selectArgs.toTypedArray()
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,selectMod, arr)
                            }
                            "video_gif"->{
                                val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                                val selectMod = "$select AND ${MediaStore.Images.Media.MIME_TYPE} = ?"
                                selectArgs.add(mimeType)
                                val arr = selectArgs.toTypedArray()
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,selectMod, arr)
                                getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,select,sArgs)
                            }
                            "video_photo" ->{
                                val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                                val selectMod = "$select AND ${MediaStore.Images.Media.MIME_TYPE} != ?"
                                selectArgs.add(mimeType)
                                val arr = selectArgs.toTypedArray()
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,selectMod, arr)
                                getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,select,sArgs)
                            }
                            else -> {
                                getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,select,sArgs)
                                getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,select,sArgs)
                            }
                         }

                            val resultAlbum = Arguments.createArray()
                            val resultMedia = Arguments.createArray()
                            for (a in galleryAlbums){
                                resultAlbum.pushMap(Arguments.makeNativeMap(a))
                            }
                            for (m in galleryMedia){
                                resultMedia.pushMap(Arguments.makeNativeMap(m))
                            }
                            val result = Arguments.createArray()
                            result.pushArray(resultAlbum)
                            result.pushArray(resultMedia)
                            Handler(Looper.getMainLooper()).post {
                                promise.resolve(result)
                            }
                        }
                }catch ( e: Exception){
                    Log.e("PhotoKit", "fetchAlbums:error $e")
                    Handler(Looper.getMainLooper()).post {
                        promise.reject(e)
                    }
                }
                Thread.currentThread().interrupt()
            }.start()

    }

    private fun getGalleryVideos(ctx: Context?,
                                 galleryAlbums: ArrayList<MutableMap<String,Any>>, galleryMedia:ArrayList<MutableMap<String,Any>>,
                                 albumsNames: ArrayList<String>,select:String?,selectArgs:Array<String>?){
        val videoQueryUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            val mediaProjection = arrayOf(
                    MediaStore.Video.Media._ID,
                    MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
                    MediaStore.Video.Media.DATE_ADDED,
                    MediaStore.Video.Media.DISPLAY_NAME
            )
        val videoCursor =
                ctx?.contentResolver?.query(videoQueryUri, mediaProjection, select, selectArgs, null)

        if (videoCursor != null && videoCursor.count > 0) {
            if (videoCursor.moveToFirst()) {
                val idColumn = videoCursor.getColumnIndex(MediaStore.Video.Media._ID)
                val dataColumn =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.BUCKET_DISPLAY_NAME)
                val dateAddedColumn =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.DATE_ADDED)
                val displayName =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.DISPLAY_NAME)

                do {
                    val id = videoCursor.getString(idColumn)
                    val data = videoCursor.getString(dataColumn)
                    val dateAdded = videoCursor.getString(dateAddedColumn)
                    val nameWithFormat = videoCursor.getString(displayName)

                    val media = mutableMapOf<String,Any>()
                    val uri = Uri.withAppendedPath(videoQueryUri, id)
                    val metadata = getVideoMetadata(ctx,uri)
                    media["albumName"] = data
                    media["displayName"] = nameWithFormat
                    media["date"] = dateAdded
                    media["duration"] = metadata[2]
                    media["height"] = metadata[1]
                    media["width"] = metadata[0]
                    media["mediaType"] = "video"
                    media["uri"] = uri.toString()

                    if (albumsNames.contains(media["albumName"] as String)) {
                        for (album in galleryAlbums) {
                            if ((album["name"] as String) == (media["albumName"] as String)) {
                                media["albumId"] = album["id"] as Int
                                album["count"] = (album["count"] as Int) + 1
                                galleryMedia.add(media)
                                break
                            }
                        }
                    } else {
                        val album = mutableMapOf<String,Any>()
                        album["id"] = generateId()
                        media["albumId"] = album["id"] as Int
                        album["name"] = media["albumName"] as String
                        album["uri"] = media["uri"] as String
                        album["mediaType"] = media["mediaType"] as String
                        album["count"] = 1
                        galleryMedia.add(media)
                        galleryAlbums.add(album)
                        albumsNames.add(media["albumName"] as String)
                    }
                } while (videoCursor.moveToNext())
                videoCursor.close()
            }else Log.e("PhotoKit", "getGalleryImages:error Cursor is  empty")
        } else Log.e("PhotoKit", "getGalleryVideos:error Cursor is null or empty")
    }

    private fun getGalleryImages(ctx: Context?,
                                 galleryAlbums: ArrayList<MutableMap<String,Any>>, galleryMedia:ArrayList<MutableMap<String,Any>>,
                                 albumsNames: ArrayList<String>, select:String?, selectArgs:Array<String>?){
        val imagesQueryUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val mediaProjection = arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
                MediaStore.Images.Media.DATE_ADDED,
                MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.MIME_TYPE
        )
        val imagesCursor =
                ctx?.contentResolver?.query(imagesQueryUri, mediaProjection, select, selectArgs, null)

        if (imagesCursor != null && imagesCursor.count > 0) {
            if (imagesCursor.moveToFirst()) {
                val idColumn = imagesCursor.getColumnIndex(MediaStore.Images.Media._ID)
                val dataColumn =
                        imagesCursor.getColumnIndex(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
                val dateAddedColumn =
                        imagesCursor.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)
                val displayName =
                        imagesCursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)

                val mimeType = imagesCursor.getColumnIndex( MediaStore.Images.Media.MIME_TYPE)

                do {
                    val id = imagesCursor.getString(idColumn)
                    val data = imagesCursor.getString(dataColumn)
                    val dateAdded = imagesCursor.getString(dateAddedColumn)
                    val nameWithFormat = imagesCursor.getString(displayName)
                    val type = imagesCursor.getString(mimeType)

                    val media = mutableMapOf<String,Any>()
                    val uri  = Uri.withAppendedPath(imagesQueryUri, id)
                    val metadata = getPhotoMetadata(ctx,uri)
                    media["albumName"] = data
                    media["displayName"] = nameWithFormat
                    media["date"] = dateAdded
                    media["duration"] = 0
                    media["height"] = metadata[1]
                    media["width"] = metadata[0]
                    media["mediaType"] = if(type.contains("image/gif")) "gif" else "image"
                    media["uri"] = uri.toString()

                    if (albumsNames.contains(media["albumName"] as String)) {
                        for (album in galleryAlbums) {
                            if (album["name"] as String == media["albumName"] as String) {
                                media["albumId"] = album["id"] as Int
                                album["count"] = (album["count"] as Int) + 1
                                galleryMedia.add(media)
                                break
                            }
                        }
                    } else {
                        //create album
                        val album = mutableMapOf<String,Any>()
                        album["id"] = generateId()
                        media["albumId"] = album["id"] as Int
                        album["name"] = media["albumName"] as String
                        album["uri"] = media["uri"] as String
                        album["mediaType"] = media["mediaType"] as String
                        album["count"] = 1
                        galleryMedia.add(media)
                        galleryAlbums.add(album)
                        albumsNames.add(media["albumName"] as String)
                    }
                } while (imagesCursor.moveToNext())
                imagesCursor.close()
            } else Log.e("PhotoKit", "getGalleryImages:error Cursor is  empty")
        } else Log.e("PhotoKit", "getGalleryImages:error Cursor is null or empty")

    }

    private var mCurrentId = 0
    private fun generateId() : Int {
        mCurrentId += 1
        return mCurrentId
    }

    private fun getVideoMetadata(ctx: Context,uri:Uri): DoubleArray {
        val retriever =  MediaMetadataRetriever()
        retriever.setDataSource(ctx, uri)
        val height = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)
        val width = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)
        val time = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
        retriever.release()

        val duration = time.toDouble() / 1000
        //milliSeg  1000 = 1 seg
        return doubleArrayOf(width.toDouble(),height.toDouble(),duration)
    }

    private fun getPhotoMetadata(ctx: Context,uri:Uri): IntArray {
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = true
        BitmapFactory.decodeStream(ctx.contentResolver.openInputStream(uri), null, options)
        //milliSeg  1000 = 1 seg
        return intArrayOf(options.outWidth,options.outHeight)
    }


}