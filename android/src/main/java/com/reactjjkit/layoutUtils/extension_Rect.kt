package com.reactjjkit.layoutUtils

import android.graphics.Point
import android.graphics.Rect
import androidx.annotation.FloatRange


fun Rect.scale(
    @FloatRange(from = 0.0, to = 1000.0) scaleX: Float,
    @FloatRange(from = 0.0, to = 1000.0) scaleY: Float
) {
    val newWidth = width() * scaleX
    val newHeight = height() * scaleY
    val deltaX = (width() - newWidth) / 2
    val deltaY = (height() - newHeight) / 2

    if(scaleX >= 0f && scaleY >= 0f)  set((left + deltaX).toInt(), (top + deltaY).toInt(), (right - deltaX).toInt(), (bottom - deltaY).toInt())
}
fun Rect.padding(padding: JJPadding){
    left += padding.left
    right -= padding.right
    top += padding.top
    bottom -= padding.bottom
}
fun Rect.flipMirror(vertical:Boolean,horizontal:Boolean){
    when {
        vertical && horizontal -> set(right, bottom, left, top)
        vertical -> set(left, bottom, right, top)
        horizontal -> set(right, top, left, bottom)
    }
}

fun Rect.percentHeight(@FloatRange(from = 0.0, to = 1.0) percent: Float):Float{
    return height() * percent
}

fun Rect.percentWidth(@FloatRange(from = 0.0, to = 1.0) percent: Float):Float{
    return width() * percent
}

fun Rect.contains(point: Point, border :Boolean = false) : Boolean{
    return  left < right && top < bottom && // check for empty first
            if(border) point.x in left..right && point.y >= top && point.y <= bottom
            else point.x in (left + 1) until right && point.y > top && point.y < bottom
}

fun Rect.contains(x: Int, y:Int, border :Boolean = false) : Boolean{
    return  left < right && top < bottom && // check for empty first
            if(border) x in left..right && y >= top && y <= bottom
            else x in (left + 1) until right && y > top && y < bottom
}


fun Rect.overflow(rect:Rect) : Boolean {
    return overflow(rect.left,rect.top,rect.right,rect.bottom)
}

fun Rect.overflow(l: Int,t:Int,r: Int,b:Int) : Boolean {
    return  left < right && top < bottom &&
            (left < l  || top < t || right > r || bottom > b)
}

