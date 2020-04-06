package com.reactjjkit.extensions

import android.graphics.*
import androidx.annotation.FloatRange
import java.lang.IllegalArgumentException


fun Path.translation(dx:Float,dy:Float,matrix: Matrix){
    matrix.reset()
    matrix.postTranslate(dx,dy)
    transform(matrix)
}

fun Path.rotation(degrees:Float,rect:RectF,matrix: Matrix){
    matrix.reset()
    matrix.postRotate(degrees,rect.centerX(),rect.centerY())
    transform(matrix)
}

fun Path.scale(scaleX: Float,
                scaleY: Float,rect:RectF,matrix:Matrix){
    matrix.reset()
    matrix.postScale(scaleX,scaleY,rect.centerX(),rect.centerY())
    transform(matrix)
}

fun Path.flipMirror(vertical: Boolean,
                    horizontal: Boolean,rect: RectF,ma:Matrix){
    ma.reset()
    when {
        vertical && horizontal -> ma.postScale(-1f, -1f, rect.centerX(), rect.centerY())
        vertical -> ma.postScale (1f,-1f, rect.centerX(), rect.centerY())
        horizontal -> ma.postScale(-1f, 1f, rect.centerX(), rect.centerY())
    }
    if(vertical || horizontal) transform(ma)
}
