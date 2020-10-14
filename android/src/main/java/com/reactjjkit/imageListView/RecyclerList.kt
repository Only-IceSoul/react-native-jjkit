package com.reactjjkit.imageListView

import android.annotation.SuppressLint
import android.content.Context
import androidx.recyclerview.widget.RecyclerView

class RecyclerList(context: Context) :RecyclerView(context) {

   private var mRequestedLayout = false
    @SuppressLint("WrongCall")
    override fun requestLayout() {
        super.requestLayout()
        if (!mRequestedLayout) {
            mRequestedLayout = true
            post {
                mRequestedLayout = false
                layout(left, top, right, bottom)
                onLayout(false, left, top, right, bottom)
            }
        }
    }
}