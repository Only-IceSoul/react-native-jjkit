package com.reactjjkit.layoutUtils

object JJUtils {

    fun api21(): Boolean{
        return android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP
    }
}