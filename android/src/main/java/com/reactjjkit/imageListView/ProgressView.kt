package com.reactjjkit.imageListView

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.util.TypedValue
import android.view.View
import android.widget.ProgressBar
import androidx.constraintlayout.widget.ConstraintLayout
import com.reactjjkit.layoutUtils.JJLayout


@SuppressLint("ViewConstructor")
class ProgressView(context: Context, sizeProgress:Int) : ConstraintLayout(context) {

    private  val mProgressView = ProgressBar(context)

    init {
        mProgressView.id = View.generateViewId()
        addView(mProgressView)
        JJLayout.clSetView(mProgressView)
                .clCenterInParent()
                .clWidth(sizeProgress)
                .clHeight(sizeProgress)
                .clDisposeView()
    }


    fun setProgressColor(color: Int) :ProgressView{
        mProgressView.indeterminateTintList = ColorStateList.valueOf(color)
        return this
    }

}