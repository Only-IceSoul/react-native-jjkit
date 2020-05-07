package com.reactjjkit.cropper

import android.graphics.*
import android.util.Base64
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.toBitmap
import androidx.core.graphics.toRect
import com.facebook.react.bridge.*
import java.io.ByteArrayOutputStream
import java.net.URL
import kotlin.math.min
import kotlin.math.round

class CropperModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context)  {

    private val reactContext: ReactApplicationContext = context

    override fun getName(): String {
        return "Cropper"
    }

    override fun getConstants(): MutableMap<String, Any> {
        return mutableMapOf("jpeg" to 0,
                "png" to 1)
    }


    @ReactMethod
    fun makeCrop64(map:ReadableMap?,promise: Promise){
        if(map != null){
            val image = map.getString("image")
            val imgRect = map.getMap("rect")
            val cw = map.getDouble("cw").toFloat()
            val ch = map.getDouble("ch").toFloat()
            val crop = map.getMap("crop")
            val wr = map.getInt("width")
            val hr = map.getInt("height")
            val quality = map.getDouble("quality").toFloat()
            val format = map.getInt("format")
            val rotation = map.getDouble("rotate").toFloat()

            if(image != null && imgRect != null && crop != null){

                val bytes = Base64.decode(image,Base64.DEFAULT)
                val options =  BitmapFactory.Options()
                options.inMutable = true
                val bmp = BitmapFactory.decodeByteArray(bytes, 0, bytes.size, options)

                val r = mapToRectF(imgRect)
                val c = mapToRectF(crop)

                val finalBmp = if(rotation > 0 ){
                     val matrix = Matrix()
                     matrix.setRotate(rotation)
                     Bitmap.createBitmap(bmp, 0, 0, bmp.width, bmp.height, matrix, false)
                }else{
                    bmp
                }

                val rf = CropperHelper.crop(finalBmp,r,cw,ch,c)
                val bf = cropBitmap(finalBmp,rf)

                val fmt = if(format == 0) Bitmap.CompressFormat.JPEG else Bitmap.CompressFormat.PNG
                if(wr > 0 && hr > 0){
                    val br = fitCenter(bf,wr,hr)
                    val output = ByteArrayOutputStream()
                    if( br.compress(fmt,(quality*100).toInt(),output) ){
                        val array = output.toByteArray()
                        val encodedString = Base64.encodeToString(array,Base64.DEFAULT)
                        promise.resolve(encodedString)
                    }else{
                        promise.resolve(null)
                    }

                }else{
                    val output = ByteArrayOutputStream()
                    if( bf.compress(fmt,(quality*100).toInt(),output) ){
                        val array = output.toByteArray()
                        val encodedString = Base64.encodeToString(array,Base64.DEFAULT)
                        promise.resolve(encodedString)
                    }else{
                        promise.resolve(null)
                    }
                }

            }else{
                promise.resolve(null)
            }
        }else{
            promise.resolve(null)

        }
    }



    @ReactMethod
    fun makeCropStatic(map:ReadableMap?,promise: Promise){
        if(map != null){
            val image = map.getString("image")
            val imgRect = map.getMap("rect")
            val cw = map.getDouble("cw").toFloat()
            val ch = map.getDouble("ch").toFloat()
            val crop = map.getMap("crop")
            val wr = map.getInt("width")
            val hr = map.getInt("height")
            val quality = map.getDouble("quality").toFloat()
            val format = map.getInt("format")
            val rotation = map.getDouble("rotate").toFloat()

            val bmp : Bitmap?

            bmp = if(image != null && image.contains("http")) {
                val url = URL(image)
                BitmapFactory.decodeStream(url.openConnection().getInputStream())
            }else{
                val id = reactContext.resources.getIdentifier(image,"drawable",reactContext.packageName)
                ContextCompat.getDrawable(reactContext,id)?.toBitmap()
            }
            if(image != null && imgRect != null && crop != null && bmp != null){

                val r = mapToRectF(imgRect)
                val c = mapToRectF(crop)

                val finalBmp = if(rotation > 0 ){
                    val matrix = Matrix()
                    matrix.setRotate(rotation)
                    Bitmap.createBitmap(bmp, 0, 0, bmp.width, bmp.height, matrix, false)
                }else{
                    bmp
                }

                val rf = CropperHelper.crop(finalBmp,r,cw,ch,c)
                val bf = cropBitmap(finalBmp,rf)

                val fmt = if(format == 0) Bitmap.CompressFormat.JPEG else Bitmap.CompressFormat.PNG
                if(wr > 0 && hr > 0){
                    val br = fitCenter(bf,wr,hr)
                    val output = ByteArrayOutputStream()
                    if( br.compress(fmt,(quality*100).toInt(),output) ){
                        val array = output.toByteArray()
                        val encodedString = Base64.encodeToString(array,Base64.DEFAULT)
                        promise.resolve(encodedString)
                    }else{
                        promise.resolve(null)
                    }

                }else{
                    val output = ByteArrayOutputStream()
                    if( bf.compress(fmt,(quality*100).toInt(),output) ){
                        val array = output.toByteArray()
                        val encodedString = Base64.encodeToString(array,Base64.DEFAULT)
                        promise.resolve(encodedString)
                    }else{
                        promise.resolve(null)
                    }
                }

            }else{
                promise.resolve(null)
            }
        }else{
            promise.resolve(null)

        }
    }

    private fun cropBitmap(bmp:Bitmap,rect:RectF) : Bitmap {
        val r = rect.toRect()
        return Bitmap.createBitmap(bmp,r.left,r.top,r.width(),r.height())
    }

    private fun mapToRectF(map:ReadableMap): RectF{
        val l = map.getDouble("left").toFloat()
        val t = map.getDouble("top").toFloat()
        val r = map.getDouble("right").toFloat()
        val b = map.getDouble("bottom").toFloat()
        return RectF(l,t,r,b)
    }

    private fun fitCenter(inBitmap:Bitmap,width: Int,height:Int) : Bitmap{
        if (inBitmap.width == width && inBitmap.height == height) {
            return inBitmap
        }
        val  widthPercentage = width /  inBitmap.width.toFloat()
        val  heightPercentage = height /  inBitmap.height.toFloat()
        val  minPercentage = min(widthPercentage, heightPercentage)

        var targetWidth = round(minPercentage * inBitmap.width).toInt()
        var targetHeight = round(minPercentage * inBitmap.height).toInt()

        if (inBitmap.width == targetWidth && inBitmap.height == targetHeight) {
            return inBitmap
        }
        targetWidth = (minPercentage * inBitmap.width).toInt()
        targetHeight = (minPercentage * inBitmap.height).toInt()

        val final = Bitmap.createBitmap(targetWidth,targetHeight,Bitmap.Config.ARGB_8888)

        val matrix =  Matrix()
        matrix.postScale(minPercentage, minPercentage)
        val canvas =  Canvas(final)
        val paint = Paint(Paint.DITHER_FLAG or Paint.FILTER_BITMAP_FLAG)
        paint.isAntiAlias = true
        canvas.drawBitmap(inBitmap,matrix,paint)
        canvas.setBitmap(null) //avoid warnings M+
        return final
    }

}