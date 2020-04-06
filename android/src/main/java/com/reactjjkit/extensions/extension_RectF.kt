package com.reactjjkit.extensions

import android.graphics.Matrix
import android.graphics.Point
import android.graphics.RectF
import androidx.annotation.FloatRange
import androidx.core.graphics.transform
import com.reactjjkit.layoutUtils.JJPadding


fun RectF.translation(x: Float, y:Float,ma:Matrix){
    ma.reset()
    ma.postTranslate(x,y)
    transform(ma)
}
fun RectF.scale(
    @FloatRange(from = 0.0, to = 1000.0) scaleX: Float,
    @FloatRange(from = 0.0, to = 1000.0) scaleY: Float, ma: Matrix
) {
    ma.reset()
    ma.postScale(scaleX,scaleY,centerX(),centerY())
     transform(ma)
}
fun RectF.flipMirror(vertical:Boolean, horizontal:Boolean,ma: Matrix){
    ma.reset()
    when {
        vertical && horizontal -> ma.postScale(-1f, -1f, centerX(), centerY())
        vertical -> ma.postScale(1f, -1f, centerX(), centerY())
        horizontal -> ma.postScale(-1f, 1f, centerX(), centerY())
    }
    if(vertical || horizontal) transform(ma)
}
fun RectF.padding(padding: JJPadding){
    left += padding.left.toFloat()
    right -= padding.right.toFloat()
    top += padding.top.toFloat()
    bottom -= padding.bottom.toFloat()
}
fun RectF.percentHeight(@FloatRange(from = 0.0, to = 1.0) percent: Float):Float{
    return height() * percent
}

fun RectF.percentWidth(@FloatRange(from = 0.0, to = 1.0) percent: Float):Float{
    return width() * percent
}

fun RectF.contains(point: Point, border :Boolean = false) : Boolean{
    return contains(point.x.toFloat(),point.y.toFloat(),border)
}
fun RectF.contains(x: Float, y:Float, border :Boolean = false) : Boolean{
    return  left < right && top < bottom && // check for empty first
            if(border) x in left..right && y >= top && y <= bottom
            else x > left && x < right && y > top && y < bottom
}
fun RectF.overflow(rect:RectF) : Boolean {
    return overflow(rect.left,rect.top,rect.right,rect.bottom)
}
fun RectF.overflow(l: Float,t:Float,r: Float,b:Float) : Boolean {
    return  left < right && top < bottom &&
            (left < l  || top < t || right > r || bottom > b)
}
