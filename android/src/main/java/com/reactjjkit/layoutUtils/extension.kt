package com.reactjjkit.layoutUtils

import java.lang.ref.WeakReference

fun <T> T.weak(): WeakReference<T> {
    return WeakReference(this)
}
