package com.reactjjkit.views

import android.annotation.SuppressLint
import android.content.Context
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import com.reactjjkit.drawables.JJOutlineClip

class ClipRectView(context: Context): ViewGroup(context) {

    private val mClip = JJOutlineClip()
    init{
        clipToOutline = true
        outlineProvider = mClip
    }
    @SuppressLint("RtlHardcoded")
    fun setGravity(gravity: String?) {

      val g =  when (gravity) {
            "bottom" ->  Gravity.BOTTOM
             "left"  -> Gravity.LEFT
              "right" ->  Gravity.RIGHT
            else ->  Gravity.TOP
      }
        mClip.setGravity(g)
    }
    fun setInset(inset: Float){
        val i = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,inset,resources.displayMetrics)
        mClip.setInset(i)
    }
    fun setProgress(num: Float) {
        mClip.setProgress(num)
        invalidateOutline()
    }
    fun getProgress() :Float { return mClip.getProgress() }
    override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {

    }

}