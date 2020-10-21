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
import androidx.core.database.getIntOrNull
import androidx.core.database.getLongOrNull
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.request.transition.Transition
import com.facebook.react.bridge.*
import java.io.ByteArrayOutputStream

class PhotoKitModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context)  {

    companion object{
        const val RESIZE_MODE_CONTAIN = "contain"
        const val RESIZE_MODE_COVER = "cover"
        const val COMPRESS_FORMAT_JPEG = "jpeg"
        const val COMPRESS_FORMAT_PNG = "png"
        const val QUERY_IMAGE = "image"
        const val QUERY_PHOTO = "photo"
        const val QUERY_GIF = "gif"
        const val QUERY_VIDEO = "video"
        const val QUERY_VIDEO_PHOTO = "video_photo"
        const val QUERY_VIDEO_GIF = "video_gif"
        const val QUERY_ALL = "all"

    }

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


  @ReactMethod
    fun clearMemoryCache(promise:Promise){
        Handler(Looper.getMainLooper()).post {
            try {
                Glide.get(reactContext).clearMemory()
                promise.resolve(true)
            }catch (e:Exception){
                promise.reject(e)
            }

        }
    }

    @ReactMethod
    fun isPermissionGranted(promise: Promise){
        try {
            val bool =  ActivityCompat.checkSelfPermission(reactContext, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                    &&  ActivityCompat.checkSelfPermission(reactContext, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
            promise.resolve(bool)
        }catch (e:Exception){
            promise.reject(e)
        }

    }


    private var mPromise : Promise? = null
    @ReactMethod
    fun requestPermission(promise: Promise){
        try{
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val i = Intent(reactContext, PermissionActivity::class.java)
                reactContext.addActivityEventListener(mListener)
                reactContext.startActivityForResult(i,200, Bundle())
                mPromise = promise
            }else{
                promise.resolve(1)
            }
        }catch (e:Exception){
            promise.reject(e)
        }

    }


    @ReactMethod
    fun requestRaw(data:String?,promise: Promise){
        try{
            val bytes = reactContext.contentResolver.openInputStream(Uri.parse(data))?.readBytes()
            val str = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
            promise.resolve(str)
        }catch (e:Exception){
            promise.reject(e)
        }
    }

    @ReactMethod
    fun requestImage(data:ReadableMap?,promise: Promise){
        val uri = try { data!!.getString("uri") } catch (e:Exception){ null}
        val width = try { data!!.getInt("width") } catch (e:Exception){  600 }
        val height =  try { data!!.getInt("height") } catch (e:Exception){  600 }
        val resizeMode =  try { data!!.getString("resizeMode") } catch (e:Exception) { RESIZE_MODE_CONTAIN }
        val quality =  try { data!!.getDouble("quality") } catch (e:Exception){ 1.0}
        val format =  try { data!!.getString("format") } catch (e:Exception){ COMPRESS_FORMAT_JPEG }


        val options = if(resizeMode == RESIZE_MODE_COVER)  RequestOptions().centerCrop().frame(0L).override(width,height)
        else  RequestOptions().fitCenter().frame(0L).override(width,height)

        Glide.with(reactContext).asBitmap().load(uri)
                .apply(options)
                .listener(object :RequestListener<Bitmap> {
                    override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<Bitmap>?, isFirstResource: Boolean): Boolean {
                        promise.reject(e)
                        return true
                    }
                    override fun onResourceReady(resource: Bitmap?, model: Any?, target: Target<Bitmap>?, dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                       try {
                           val bytesStream = ByteArrayOutputStream()
                           val q = (100 * quality).toInt()
                           if (format == COMPRESS_FORMAT_PNG){
                               resource!!.compress(Bitmap.CompressFormat.PNG, q, bytesStream)
                           }else{
                               resource!!.compress(Bitmap.CompressFormat.JPEG, q, bytesStream)
                           }
                           val bytes = bytesStream.toByteArray()
                           val str = android.util.Base64.encodeToString(bytes, android.util.Base64.DEFAULT)
                           promise.resolve(str)
                       }catch (e:Exception){
                           promise.reject(e)
                       }
                        return true
                    }
                })
                .into(object: CustomTarget<Bitmap>(){
                    override fun onLoadCleared(placeholder: Drawable?) {}
                    override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {}
                })

    }



    @ReactMethod
    fun fetch(query:ReadableMap?, promise: Promise)  {
        Thread {
            try{
                val media = try {  query!!.getString("query")!! }catch(e: java.lang.Exception) {  QUERY_ALL }
                val names =  try {  query!!.getArray("names") }catch(e: java.lang.Exception) {  null }
                val limit = try {   query!!.getInt("limit") }catch(e: java.lang.Exception) {  -1 }
                val offset = try {   query!!.getInt("offset") }catch(e: java.lang.Exception) {  -1 }


                val galleryAlbums: ArrayList<MutableMap<String,Any>> = ArrayList()
                val galleryMedia: ArrayList<MutableMap<String,Any>> = ArrayList()
                val albumsNames: ArrayList<String> = ArrayList()
                val l = if (limit < 0) -1 else limit
                val off =  if (offset < 0) -1 else offset

                val whereArgs = mutableListOf<String>()
                var where = ""
                if(names != null){
                    for (i in 0 until names.size()){
                        val s = names.getString(i)
                        if(!s.isNullOrEmpty()) {
                            whereArgs.add(s)
                        }
                    }
                }
                if (whereArgs.size > 1){
                    whereArgs.forEachIndexed { index, _ ->
                        where += if (index != whereArgs.size - 1)
                            "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ? OR "
                        else
                            "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ?"
                    }
                }else if (whereArgs.size > 0){
                    where = "${MediaStore.Video.Media.BUCKET_DISPLAY_NAME} = ?"
                }

                val wFilterImage = if(where.isNotEmpty()) "($where) AND ${MediaStore.Images.Media.MIME_TYPE} != ?"  else "${MediaStore.Images.Media.MIME_TYPE} != ?"
                val wFilterGif = if(where.isNotEmpty()) "($where) AND ${MediaStore.Images.Media.MIME_TYPE} == ?"  else "${MediaStore.Images.Media.MIME_TYPE} == ?"
                val wVideo = if(where.isNotEmpty()) where else null
                val argsVideo = if(whereArgs.isNotEmpty()) whereArgs.toTypedArray() else null
                val wImage = if(where.isNotEmpty()) where else null
                val argsImage = if(whereArgs.isNotEmpty()) whereArgs.toTypedArray() else null

                when(media){
                    QUERY_IMAGE -> {

                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wImage, argsImage,l,off)
                    }
                    QUERY_VIDEO -> {
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,wVideo,argsVideo,l,off)
                    }
                    QUERY_PHOTO ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        whereArgs.add(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wFilterImage,whereArgs.toTypedArray(),l,off)
                    }
                    QUERY_GIF ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        whereArgs.add(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wFilterGif,whereArgs.toTypedArray(),l,off)
                    }
                    QUERY_VIDEO_GIF->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        whereArgs.add(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wFilterGif,whereArgs.toTypedArray(),l,off)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,wVideo,argsVideo,l,off)
                    }
                    QUERY_VIDEO_PHOTO ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        whereArgs.add(mimeType)
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wFilterImage,whereArgs.toTypedArray(),l,off)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,wVideo,argsVideo,l,off)
                    }
                    else -> {
                        getGalleryImages(reactContext,galleryAlbums,galleryMedia,albumsNames,wImage,argsImage,l,off)
                        getGalleryVideos(reactContext,galleryAlbums,galleryMedia,albumsNames,wVideo,argsVideo,l,off)
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
                val result = Arguments.createMap()
                result.putArray("albums",resultAlbum)
                result.putArray("media",resultMedia)


                Handler(Looper.getMainLooper()).post {
                    promise.resolve(result)
                }

            }catch ( e: Exception){
                Log.e("PhotoKit", "fetch:error $e")
                Handler(Looper.getMainLooper()).post {
                    promise.reject(e)
                }

            }
            Thread.currentThread().interrupt()
        }.start()
    }

    @ReactMethod
    fun fetchAlbums(media:String?,promise:Promise){
        Thread{
            try{
                val galleryAlbums: ArrayList<MutableMap<String,Any>> = ArrayList()
                val albumsNames: ArrayList<String> = ArrayList()
                val currentAlbums: ArrayList<String> = ArrayList()
                when(media){
                    "image" -> {
                        getAlbumNames(reactContext,albumsNames,null,null)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,null,null)
                    }
                    "video" -> {
                        getAlbumNames(reactContext,albumsNames,null,null,true)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,null,null,true)
                    }
                    "photo" ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} != ?"
                        val arr = arrayOf(mimeType)
                        getAlbumNames(reactContext,albumsNames,select,arr)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr)
                    }
                    "gif"->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} = ?"
                        val arr = arrayOf(mimeType)
                        getAlbumNames(reactContext,albumsNames,select,arr)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr)
                    }
                    "video_gif"->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} = ?"
                        val arr = arrayOf(mimeType)
                        getAlbumNames(reactContext,albumsNames,select,arr)
                        getAlbumNames(reactContext,albumsNames,select,arr,true)

                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr,true)
                    }
                    "video_photo" ->{
                        val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension("gif") ?: "image/gif"
                        val select = "${MediaStore.Images.Media.MIME_TYPE} != ?"
                        val arr = arrayOf(mimeType)
                        getAlbumNames(reactContext,albumsNames,select,arr)
                        getAlbumNames(reactContext,albumsNames,select,arr,true)

                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,select,arr,true)
                    }
                    else -> {
                        getAlbumNames(reactContext,albumsNames,null,null)
                        getAlbumNames(reactContext,albumsNames,null,null,true)

                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,null,null)
                        getAlbumsMap(reactContext,galleryAlbums,albumsNames,currentAlbums,null,null,true)
                    }
                }
                val resultAlbum = Arguments.createArray()
                for (a in galleryAlbums){
                    resultAlbum.pushMap(Arguments.makeNativeMap(a))
                }

                Handler(Looper.getMainLooper()).post {
                    promise.resolve(resultAlbum)
                }
            }catch ( e: Exception){
                Log.e("PhotoKit", "fetchAlbumNames:error $e")
                Handler(Looper.getMainLooper()).post {
                    promise.reject(e)
                }
            }
            Thread.currentThread().interrupt()
        }.start()

    }

    private fun getAlbumNames(ctx: Context?,albumsNames: ArrayList<String>, select:String?, selectArgs:Array<String>?, video:Boolean=false){
        val imagesQueryUri = if(video) MediaStore.Video.Media.EXTERNAL_CONTENT_URI else MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val mediaProjection = arrayOf(
                "DISTINCT ${MediaStore.Video.Media.BUCKET_DISPLAY_NAME}"
        )
        val cursor =
                ctx?.contentResolver?.query(imagesQueryUri, mediaProjection, select, selectArgs, null)

        if (cursor != null && cursor.count > 0) {
            if (cursor.moveToFirst()) {

                val dataColumn =
                        cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
                do {
                    val name = cursor.getString(dataColumn)
                    if(!albumsNames.contains(name)) {
                        albumsNames.add(name)
                    }
                } while (cursor.moveToNext())
                cursor.close()
            } else{
                Log.e("PhotoKit", "getAlbumNames:error Cursor is  empty")
                cursor.close()
            }
        } else {
            Log.e("PhotoKit", "getAlbumNames:error Cursor is null or empty")
            cursor?.close()
        }
    }

    private fun getAlbumsMap(ctx: Context?, galleryAlbums: ArrayList<MutableMap<String,Any>>,albumsNames: ArrayList<String>,currentAlbums:ArrayList<String>, select:String?, selectArgs:Array<String>?, video:Boolean=false){
        val queryUri = if(video) MediaStore.Video.Media.EXTERNAL_CONTENT_URI else MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = if(video) arrayOf(
                MediaStore.Video.Media._ID,
                MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
                MediaStore.Video.Media.DATE_ADDED
        ) else arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
                MediaStore.Images.Media.DATE_ADDED,
                MediaStore.Images.Media.MIME_TYPE
        )
        val orderBy = "${MediaStore.Images.Media.DATE_ADDED} DESC"



        albumsNames.forEach {

            val whereMod = if (select != null) "($select) AND ${MediaStore.Images.Media.BUCKET_DISPLAY_NAME} = ?" else "${MediaStore.Images.Media.BUCKET_DISPLAY_NAME} = ?"
            val argsMod = if (selectArgs != null) arrayOf(*selectArgs, it) else arrayOf(it)
            val cursor =
                    ctx?.contentResolver?.query(queryUri, projection, whereMod, argsMod, orderBy)
            if (cursor != null && cursor.count > 0) {
                if (cursor.moveToFirst()) {
                    val idColumn = cursor.getColumnIndex(MediaStore.Images.Media._ID)

                    val id = cursor.getString(idColumn)
                    val uri = Uri.withAppendedPath(queryUri, id)
                    val type = if (video) "" else cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.MIME_TYPE))
                    if(!currentAlbums.contains(it)) {
                        val album = mutableMapOf<String, Any>()
                        album["id"] = generateId()
                        album["name"] = it
                        album["uri"] = uri.toString()
                        album["mediaType"] = if (video) "video" else if (type.contains("image/gif")) "gif" else "image"
                        album["count"] = cursor.count

                        galleryAlbums.add(album)
                        currentAlbums.add(it)
                    }else{
                        galleryAlbums.forEachIndexed { _, item ->
                            if(item["name"] as String == it){
                                item["count"] = item["count"] as Int + cursor.count
                            }
                        }
                    }
                    cursor.close()
                } else {
                    Log.e("PhotoKit", "getAlbumsNamesMap:error Cursor is  empty")
                    cursor.close()
                }
            } else {
                Log.e("PhotoKit", "getAlbumsNamesMap:error Cursor is null or empty")
                cursor?.close()
            }

        }


    }

    private fun getGalleryVideos(ctx: Context?,
                                 galleryAlbums: ArrayList<MutableMap<String,Any>>, galleryMedia:ArrayList<MutableMap<String,Any>>,
                                 albumsNames: ArrayList<String>,select:String?,selectArgs:Array<String>?,limit:Int,offset:Int){
        val videoQueryUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            val mediaProjection = arrayOf(
                    MediaStore.Video.Media._ID,
                    MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
                    MediaStore.Video.Media.DATE_ADDED,
                    MediaStore.Video.Media.DISPLAY_NAME,
                    MediaStore.Video.Media.WIDTH,
                    MediaStore.Video.Media.HEIGHT,
                    MediaStore.Video.Media.DURATION
            )

        val orderBy = "${MediaStore.Images.Media.DATE_ADDED} DESC"
        val l = " LIMIT $limit"
        val off = " OFFSET $offset"

        val videoCursor =
                ctx?.contentResolver?.query(videoQueryUri, mediaProjection, select, selectArgs, orderBy+l+off)

        if (videoCursor != null && videoCursor.count > 0) {
            if (videoCursor.moveToFirst()) {
                val idColumn = videoCursor.getColumnIndex(MediaStore.Video.Media._ID)
                val dataColumn =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.BUCKET_DISPLAY_NAME)
                val dateAddedColumn =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.DATE_ADDED)
                val displayName =
                        videoCursor.getColumnIndex(MediaStore.Video.Media.DISPLAY_NAME)
                val wc = videoCursor.getColumnIndex( MediaStore.Video.Media.WIDTH)
                val hc = videoCursor.getColumnIndex( MediaStore.Video.Media.HEIGHT)
                val dc = videoCursor.getColumnIndex(MediaStore.Video.Media.DURATION)

                do {
                    val id = videoCursor.getString(idColumn)
                    val data = videoCursor.getString(dataColumn)
                    val dateAdded = videoCursor.getString(dateAddedColumn)
                    val nameWithFormat = videoCursor.getString(displayName)

                    val media = mutableMapOf<String,Any>()
                    val uri = Uri.withAppendedPath(videoQueryUri, id)

                    val d = videoCursor.getLongOrNull(dc) ?: 0L
                    val w = videoCursor.getIntOrNull(wc) ?: 0
                    val h = videoCursor.getIntOrNull(hc) ?: 0

                    media["albumName"] = data
                    media["displayName"] = nameWithFormat
                    media["date"] = dateAdded.toLong()
                    media["duration"] = d.toDouble() / 1000
                    media["height"] = h
                    media["width"] = w
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
            }else {
                Log.e("PhotoKit", "getGalleryImages:error Cursor is  empty")
                videoCursor.close()
            }
        } else {
            Log.e("PhotoKit", "getGalleryVideos:error Cursor is null or empty")
            videoCursor?.close()
        }
    }

    private fun getGalleryImages(ctx: Context?,
                                 galleryAlbums: ArrayList<MutableMap<String,Any>>, galleryMedia:ArrayList<MutableMap<String,Any>>,
                                 albumsNames: ArrayList<String>, select:String?, selectArgs:Array<String>?,limit:Int,offset:Int){
        val imagesQueryUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val mediaProjection = arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
                MediaStore.Images.Media.DATE_ADDED,
                MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.MIME_TYPE,
                MediaStore.Images.Media.WIDTH,
                MediaStore.Images.Media.HEIGHT
        )

        val orderBy = "${MediaStore.Images.Media.DATE_ADDED} DESC"
        val l = " LIMIT $limit"
        val off = " OFFSET $offset"

        val imagesCursor =
                ctx?.contentResolver?.query(imagesQueryUri, mediaProjection, select, selectArgs, orderBy+l+off)

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
                val wc = imagesCursor.getColumnIndex( MediaStore.Images.Media.WIDTH)
                val hc = imagesCursor.getColumnIndex( MediaStore.Images.Media.HEIGHT)
                do {
                    val id = imagesCursor.getString(idColumn)
                    val data = imagesCursor.getString(dataColumn)
                    val dateAdded = imagesCursor.getString(dateAddedColumn)
                    val nameWithFormat = imagesCursor.getString(displayName)
                    val type = imagesCursor.getString(mimeType)
                    val w = imagesCursor.getIntOrNull(wc) ?: 0
                    val h = imagesCursor.getIntOrNull(hc) ?: 0

                    val media = mutableMapOf<String,Any>()
                    val uri  = Uri.withAppendedPath(imagesQueryUri, id)

                    media["albumName"] = data
                    media["displayName"] = nameWithFormat
                    media["date"] = dateAdded.toLong()
                    media["duration"] = 0
                    media["height"] = w
                    media["width"] = h
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
            } else {
                Log.e("PhotoKit", "getGalleryImages:error Cursor is  empty")
                imagesCursor.close()
            }
        } else {
            Log.e("PhotoKit", "getGalleryImages:error Cursor is null or empty")
            imagesCursor?.close()
        }

    }

    private var mCurrentId = 0
    private fun generateId() : Int {
        mCurrentId += 1
        return mCurrentId
    }

    private fun getVideoMetadata(ctx: Context,uri:Uri): DoubleArray {
        return try{
            val retriever =  MediaMetadataRetriever()
            retriever.setDataSource(ctx, uri)
//            val height = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT) ?: "0"
//            val width = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH) ?: "0"
            val time =  retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION) ?: "0"
            retriever.release()
            val duration = time.toDouble() / 1000
            //milliSeg  1000 = 1 seg
            doubleArrayOf(0.0,0.0,duration)
        }catch (e:Exception){
            doubleArrayOf(0.0,0.0,0.0)
        }



    }

    private fun getPhotoMetadata(ctx: Context,uri:Uri): IntArray {
        val options = BitmapFactory.Options()
        options.inJustDecodeBounds = true
        BitmapFactory.decodeStream(ctx.contentResolver.openInputStream(uri), null, options)
        //milliSeg  1000 = 1 seg
        return intArrayOf(options.outWidth,options.outHeight)
    }


}