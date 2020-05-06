package com.reactjjkit.cropper

import android.graphics.Bitmap
import android.graphics.RectF
import kotlin.math.abs

object CropperHelper {

    fun crop(image: Bitmap, imageRect: RectF, cw:Float, ch:Float, crop: RectF) : RectF {
        val w = crop.width() / imageRect.width() * image.width
        val h = crop.height() / imageRect.height() * image.height
        var x = crop.left
        var y = crop.top
        if (imageRect.left < 0) {
            x = abs(imageRect.left) + crop.left
        }else if (imageRect.left > 0) {
            x = crop.left - imageRect.left
        }
        if (imageRect.top < 0) {
            y = abs(imageRect.top) + crop.top
        }else if (imageRect.top > 0) {
            y = crop.top - imageRect.top
        }

        x = x / imageRect.width() * image.width
        y = y / imageRect.height() * image.height

        return RectF(x,y,x+w,y+h)
    }
}