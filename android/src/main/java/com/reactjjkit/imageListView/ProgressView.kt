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
class ProgressView(context: Context, sizeProgress:Float) : ConstraintLayout(context) {

    private  val mProgressView = ProgressBar(context)

    init {
        val size = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,sizeProgress * 0.8f,context.resources.displayMetrics).toInt()
        mProgressView.id = View.generateViewId()
        addView(mProgressView)
        JJLayout.clSetView(mProgressView)
                .clCenterInParent()
                .clWidth(size)
                .clHeight(size)
                .clDisposeView()

    }


    fun setProgressColor(color: Int) :ProgressView{
        mProgressView.indeterminateTintList = ColorStateList.valueOf(color)
        return this
    }

}