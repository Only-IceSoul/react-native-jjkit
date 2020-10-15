package com.reactjjkit.imageListView

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.Outline
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.RoundRectShape
import android.view.View
import android.view.ViewOutlineProvider
import android.widget.ImageView
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import com.reactjjkit.R
import com.reactjjkit.layoutUtils.JJColorDrawable
import com.reactjjkit.layoutUtils.JJLayout
import com.reactjjkit.layoutUtils.JJScreen

@SuppressLint("ViewConstructor")
class PhotoCell(context: Context, colorAccent : Int, iconPreviewGravity: Int) : ConstraintLayout(context),SelectableView {


    private val mColorAccent = colorAccent
    private val mImageView = AppCompatImageView(context)
    private val mImageSelection = AppCompatImageView(context)


    private val mBgRing = JJColorDrawable().setShape(1)
        .setFillColor(Color.parseColor("#40FFFFFF"))
        .setStroke(JJScreen.responsiveSize(5,4,3,2).toFloat(),Color.WHITE)

    private var mPosition = 0

    init {
        val colorState = ColorStateList(arrayOf(intArrayOf(android.R.attr.state_pressed) ,intArrayOf(-android.R.attr.state_pressed)), intArrayOf(Color.BLACK,Color.BLACK))
        val bg = GradientDrawable()
        bg.shape = GradientDrawable.RECTANGLE
        bg.color = ColorStateList.valueOf(Color.WHITE)
        bg.cornerRadii = floatArrayOf(0f,0f,0f,0f,0f,0f,0f,0f)
        val rect = RoundRectShape(floatArrayOf(0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f), null, null)
        val shape = ShapeDrawable(rect)
        background = RippleDrawable(colorState,bg,shape)

        clipToOutline = true
        outlineProvider = object: ViewOutlineProvider() {
            override fun getOutline(view: View?, outline: Outline?) {
                outline?.setRoundRect(0,0,view!!.width,view.height,0f)
            }
        }

        mImageSelection.id = generateId()
        mImageView.id = generateId()
        addView(mImageView)
        addView(mImageSelection)


        mImageView.scaleType = ImageView.ScaleType.CENTER_CROP

        mImageSelection.background = mBgRing
        mImageSelection.scaleType = ImageView.ScaleType.FIT_CENTER
        val padImgSelect = JJScreen.pointW(20)
        mImageSelection.setPaddingRelative(padImgSelect,padImgSelect,padImgSelect,padImgSelect)


        val sizeIcon = JJScreen.pointW(80)


        JJLayout.clSetView(mImageView)
            .clFillParent()
            .clDisposeView()
            .clSetView(mImageSelection)
            .clTopToTopParent(JJScreen.pointW(20))
            .clEndToEndParent(JJScreen.pointW(20))
            .clHeight(sizeIcon).clWidth(sizeIcon)

            .clDisposeView()

    }

    private var mGeneratorId = 1
    private fun generateId(): Int {
        mGeneratorId++
        return mGeneratorId
    }


    fun isIconSelectionVisible(boolean: Boolean) : PhotoCell {
        mImageSelection.visibility = if(boolean) View.VISIBLE else View.GONE
        return this
    }

    fun setImageTransitionName(string: String): PhotoCell {
        mImageView.transitionName = string
        return this
    }

    fun setItemPosition(pos:Int): PhotoCell {
        mPosition = pos
        return this
    }

    fun getPosition(): Int {
        return mPosition
    }

    fun getImageView(): AppCompatImageView {
        return mImageView
    }

    override fun isSelected(boolean: Boolean) {
        if(boolean) {
            mImageSelection.setImageResource(R.drawable.ic_done_medium)
            mBgRing.setFillColor(mColorAccent)
            mBgRing.invalidateSelf()
        }
        else {
            mImageSelection.setImageBitmap(null)
            mBgRing.setFillColor(Color.parseColor("#40FFFFFF"))
            mBgRing.invalidateSelf()

        }

    }



}