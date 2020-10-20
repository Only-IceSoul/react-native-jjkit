package com.reactjjkit.imageListView

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.Outline
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
class PhotoCell(context: Context, colorAccent : Int,
selectableIconSize: Int = JJScreen.dp(11f).toInt() ) : ConstraintLayout(context),SelectableView {


    private val mColorAccent = colorAccent
    private val mImageView = AppCompatImageView(context)
    private val mImageSelectionContainer = ConstraintLayout(context)
    private val mImageSelection = AppCompatImageView(context)


    private val mBgRing = JJColorDrawable().setShape(1)
        .setFillColor(Color.parseColor("#40FFFFFF"))
        .setStroke(selectableIconSize*0.1f,Color.WHITE)

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

        mImageSelectionContainer.id = generateId()
        mImageSelection.id = generateId()
        mImageView.id = generateId()
        addView(mImageView)
        mImageSelectionContainer.addView(mImageSelection)
        addView(mImageSelectionContainer)


        mImageView.scaleType = ImageView.ScaleType.CENTER_CROP

        mImageSelectionContainer.background = mBgRing
        mImageSelection.scaleType = ImageView.ScaleType.FIT_CENTER



        val sizeSelectImage = (selectableIconSize*0.48f).toInt()
        JJLayout.clSetView(mImageView)
                .clFillParent()
                .clDisposeView()

                .clSetView(mImageSelectionContainer)
                .clTopToTopParent(JJScreen.pointW(20))
                .clEndToEndParent(JJScreen.pointW(20))
                .clHeight(selectableIconSize).clWidth(selectableIconSize)

                .clSetView(mImageSelection)
                .clHeight(sizeSelectImage)
                .clWidth(sizeSelectImage)
                .clCenterInParent()
                .clDisposeView()

    }

    private var mGeneratorId = 1
    private fun generateId(): Int {
        mGeneratorId++
        return mGeneratorId
    }


    fun isIconSelectionVisible(boolean: Boolean) : PhotoCell {
        mImageSelectionContainer.visibility = if(boolean) View.VISIBLE else View.GONE
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