package com.reactjjkit.layoutUtils

import android.content.res.Resources
import android.util.TypedValue
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

object JJScreen {

    private val displayMetrics = Resources.getSystem().displayMetrics
    val density = Resources.getSystem().displayMetrics.density

  

    fun percentWidth(percent: Float): Int {
        val width = min(displayMetrics.widthPixels, displayMetrics.heightPixels)
        return (percent * width).roundToInt()
    }

    fun percentHeight(percent: Float): Int {
        val height = max(displayMetrics.widthPixels, displayMetrics.heightPixels)
        return (percent * height).roundToInt()
    }

    fun percentWidthFloat(percent: Float): Float {
        val width = min(displayMetrics.widthPixels, displayMetrics.heightPixels)
        return (percent * width)
    }

    fun percentHeightFloat(percent: Float): Float {
        val height = max(displayMetrics.widthPixels, displayMetrics.heightPixels)
        return (percent * height)
    }


    fun width(): Int {
        return min(displayMetrics.widthPixels, displayMetrics.heightPixels)
    }

    fun height(): Int {
        return max(displayMetrics.widthPixels, displayMetrics.heightPixels)
    }


    //base 2960
    fun point(p: Int): Int{
        val value = when(p){
            in Int.MIN_VALUE..4 ->  5f / 2960f
            else -> {
                p / 2960f
            }
        }
        return (height() * value).roundToInt()
    }

    fun point(p: Float): Float{
        val value = when(p){
            in Float.MIN_VALUE..4f ->  5f / 2960f
            else -> {
                p / 2960f
            }
        }
        return height() * value
    }

    fun pointW(p: Int): Int{
        val value = when(p){
            in Int.MIN_VALUE..3 -> 3f / 1440f
            else -> {
                p / 1440f
            }
        }
        return (width() * value).roundToInt()
    }

    fun pointW(p: Float): Float{
        val value = when(p){
            in Float.MIN_VALUE..3f -> 3f / 1440f
            else -> {
                p / 1440f
            }
        }
        return width() * value
    }

    fun responsiveSize(xHigher: Int, higher: Int = 0, medium: Int = 0, small: Int = 0): Int = when((height())){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0) xHigher  else 0
        in 2001..2599 -> if(higher > 0) higher  else if(xHigher > 0) xHigher  else 0
        in 1300..2000 ->  if(medium > 0) medium else if(xHigher > 0) xHigher  else 0
        in 1..1299 -> if(small > 0) small else if(xHigher > 0) xHigher  else 0
        else ->  if(xHigher > 0) xHigher  else 0
    }

    fun responsiveSize(xHigher: Float, higher: Float = 0f, medium: Float = 0f, small: Float = 0f): Float = when((height())){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0f) xHigher  else 0f
        in 2001..2599 -> if(higher > 0f) higher  else if(xHigher > 0f) xHigher  else 0f
        in 1300..2000 ->  if(medium > 0f) medium else if(xHigher > 0f) xHigher  else 0f
        in 1..1299 -> if(small > 0f) small else if(xHigher > 0f) xHigher  else 0f
        else ->  if(xHigher > 0f) xHigher  else 0f
    }

    fun responsiveSizePercentScreenHeight(xHigher: Float, higher: Float = 0f, medium: Float = 0f, small: Float = 0f): Int = when((height())){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0f) percentHeight(xHigher)  else 0
        in 2001..2599 -> if(higher > 0f) percentHeight(higher)  else if(xHigher > 0f) percentHeight(xHigher)  else 0
        in 1300..2000 ->  if(medium > 0f) percentHeight(medium) else if(xHigher > 0f) percentHeight(xHigher)  else 0
        in 1..1299 -> if(small > 0f) percentHeight(small) else if(xHigher > 0f) percentHeight(xHigher)  else 0
        else ->  if(xHigher > 0f) percentHeight(xHigher)  else 0
    }

    fun responsiveSizePercentScreenWidth(xHigher: Float, higher: Float = 0f, medium: Float = 0f, small: Float = 0f): Int = when((height())){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0f) percentWidth(xHigher)  else 0
        in 2001..2599 -> if(higher > 0f) percentWidth(higher)  else  if(xHigher > 0f) percentWidth(xHigher)  else 0
        in 1300..2000 ->  if(medium > 0f) percentWidth(medium) else  if(xHigher > 0f) percentWidth(xHigher)  else 0
        in 1..1299 -> if(small > 0f) percentWidth(small) else  if(xHigher > 0f) percentWidth(xHigher)  else 0
        else -> if(xHigher > 0f) percentWidth(xHigher)  else 0
    }

    fun responsiveTextSize(xHigher: Float, higher: Float = 0f, medium: Float = 0f, small: Float = 0f, xSmall: Float = 0f): Float = when(height()){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0f) xHigher  else 0f
        in 2000..2599 -> if(higher > 0f) higher  else if(xHigher > 0f) xHigher  else 0f
        in 1400..1999 ->  if(medium > 0f) medium else if(xHigher > 0f) xHigher  else 0f
        in 900..1399 ->   if(small > 0f) small else if(xHigher > 0f) xHigher  else 0f
        in 1..899 ->  if(xSmall > 0f) xSmall else if(xHigher > 0f) xHigher  else 0f
        else ->  if(xHigher > 0f) xHigher  else 0f
    }

    fun responsiveTextSize(xHigher: Int, higher: Int = 0, medium: Int = 0, small: Int = 0, xSmall: Int = 0): Int = when(height()){
        in 2600..Int.MAX_VALUE ->  if(xHigher > 0) xHigher  else 0
        in 2000..2599 -> if(higher > 0) higher  else if(xHigher > 0) xHigher  else 0
        in 1400..1999 ->  if(medium > 0) medium else if(xHigher > 0) xHigher  else 0
        in 900..1399 ->   if(small > 0) small else if(xHigher > 0) xHigher  else 0
        in 1..899 ->  if(xSmall > 0) xSmall else if(xHigher > 0) xHigher  else 0
        else ->  if(xHigher > 0) xHigher  else 0
    }

    fun navBarHeight():Int{
        return responsiveSizePercentScreenHeight(0.07f,0f,0f,0.08f)
    }

    fun dp(dp: Float): Float {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,dp, displayMetrics)
    }

    fun sp(dp: Float): Float {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP,dp, displayMetrics)
    }


}