package com.reactjjkit.imageListView

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.Outline
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.RoundRectShape
import android.view.Gravity
import android.view.View
import android.view.ViewOutlineProvider
import android.widget.ImageView
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet
import com.reactjjkit.R
import com.reactjjkit.layoutUtils.JJColorDrawable
import com.reactjjkit.layoutUtils.JJLayout
import com.reactjjkit.layoutUtils.JJScreen
import kotlin.math.min

@SuppressLint("ViewConstructor")
class VideoCell(context: Context, colorAccent: Int,
                selectableIconSize: Int = JJScreen.dp(11f).toInt(),
                    videoIconSize:Int = JJScreen.dp(14f).toInt(),
                durationTextSize:Float =  11f
                ) : ConstraintLayout(context),SelectableView {


    private val mColorAccent = colorAccent
    private val mImageView = AppCompatImageView(context)
    private val mImageSelectionContainer = ConstraintLayout(context)
    private val mImageSelection = AppCompatImageView(context)
    private val mTextDuration = AppCompatTextView(context)
    private val mImageVideoIcon = AppCompatImageView(context)


    private val mBgRing = JJColorDrawable().setShape(1)
        .setFillColor(Color.parseColor("#40FFFFFF"))
        .setStroke(selectableIconSize*0.1f,Color.WHITE)

    private val mVideoIconSize = videoIconSize
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
        mImageVideoIcon.id = generateId()
        mImageSelection.id = generateId()
        mImageView.id = generateId()
        mTextDuration.id = generateId()

        addView(mImageView)
        mImageSelectionContainer.addView(mImageSelection)
        addView(mImageSelectionContainer)
        addView(mTextDuration)
        addView(mImageVideoIcon)


        mTextDuration.typeface = Typeface.SANS_SERIF
        mTextDuration.textSize = durationTextSize
        mTextDuration.setTextColor(Color.WHITE)
        mTextDuration.text = "00:00"
        mTextDuration.setBackgroundColor(Color.parseColor("#80262626"))
        val padding = JJScreen.pointW(25)
        mTextDuration.setPaddingRelative(padding,0,padding,0)
        mTextDuration.clipToOutline = true
        mTextDuration.outlineProvider = object: ViewOutlineProvider(){
            override fun getOutline(view: View?, outline: Outline?) {
                val radius = min(view!!.width,view.height) / 2f
                outline?.setRoundRect(0,0,view.width,view.height,radius)
            }

        }

        mImageView.scaleType = ImageView.ScaleType.CENTER_CROP

        mImageSelectionContainer.background = mBgRing
        mImageSelection.scaleType = ImageView.ScaleType.FIT_CENTER



        mImageVideoIcon.setImageResource(R.drawable.ic_video)


        val margin = JJScreen.pointW(20)
        val sizeSelectImage = (selectableIconSize*0.48f).toInt()

        JJLayout.clSetView(mImageView)
                .clFillParent()

                .clSetView(mImageSelectionContainer)
                .clTopToTopParent(margin)
                .clEndToEndParent(margin)
                .clHeight(selectableIconSize)
                .clWidth(selectableIconSize)

                .clSetView(mImageSelection)
                .clHeight(sizeSelectImage).clWidth(sizeSelectImage)
                .clCenterInParent()

                .clSetView(mImageVideoIcon)
                .clHeight(mVideoIconSize).clWidth(mVideoIconSize)

                .clDisposeView()

        JJLayout.clSetView(mTextDuration)
            .clHeight(ConstraintSet.WRAP_CONTENT)
            .clWidth(ConstraintSet.WRAP_CONTENT)
            .clDisposeView()

        applyGravityToDuration( Gravity.END or Gravity.BOTTOM)
        applyGravityToIconVideo(Gravity.START or Gravity.BOTTOM)


    }

    private var mGeneratorId = 1
    private fun generateId(): Int {
        mGeneratorId++
        return mGeneratorId
    }



    fun isIconSelectionVisible(boolean: Boolean) : VideoCell {
        mImageSelectionContainer.visibility = if(boolean) View.VISIBLE else View.GONE
        return this
    }

    fun setImageTransitionName(string: String): VideoCell {
        mImageView.transitionName = string
        return this
    }

    private var mPosition = 0
    fun setItemPosition(pos:Int): VideoCell {
        mPosition = pos
        return this
    }

    fun getPosition(): Int {
        return mPosition
    }
    fun getImageView(): AppCompatImageView {
        return mImageView
    }


    fun setTextDuration(milliSeg:Long ): VideoCell {
        val timeString = milliSegToTimeString(milliSeg)
        mTextDuration.text = timeString
        return this
    }

    fun isIconVisible(boolean: Boolean): VideoCell {
        val vis = if(boolean) View.VISIBLE else View.GONE
        JJLayout.clSetView(mImageVideoIcon)
            .clVisibility(vis)
            .clDisposeView()
        return this
    }

    fun isDurationVisible(boolean: Boolean): VideoCell {
        val vis = if(boolean) View.VISIBLE else View.GONE
        JJLayout.clSetView(mTextDuration)
            .clVisibility(vis)
            .clDisposeView()
        return this
    }


    private fun milliSegToTimeString(millis: Long): String{
        var seconds = 0
        var minutes = 0
        var hours = 0
        if (millis >= 1000) {
            seconds = (millis / 1000).toInt()
            if (seconds > 60) {
                minutes = (seconds / 60)
                seconds %= 60
                if (minutes > 60) {
                    hours = minutes / 60
                    minutes %= 60
                }
            }
        }

        val secondString = if(seconds > 9) "$seconds" else "0$seconds"
        val minutesString = if(minutes > 9) "$minutes" else "0$minutes"
        val hoursString =  if(hours > 9) "$hours" else "0$hours"
        return if(hours > 0) "$hoursString:$minutesString:$secondString" else "$minutesString:$secondString"
    }


    override fun isSelected(boolean: Boolean)  {
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


    private fun applyGravityToIconVideo(gravity:Int){
        val margin = JJScreen.pointW(20)
        when(gravity) {
            Gravity.END or Gravity.BOTTOM-> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clBottomToBottomParent(margin)
                        .clEndToEndParent(margin)
                        .clDisposeView()
            }
            Gravity.RIGHT or Gravity.BOTTOM-> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clBottomToBottomParent(margin)
                        .clEndToEndParent(margin)
                        .clDisposeView()
            }

            Gravity.START or Gravity.BOTTOM -> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clBottomToBottomParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.LEFT or Gravity.BOTTOM -> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clBottomToBottomParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.LEFT or Gravity.TOP -> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clTopToTopParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.START or Gravity.TOP -> {
                JJLayout.clSetView(mImageVideoIcon)
                        .clTopToTopParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }
        }

    }
    private fun applyGravityToDuration(gravity:Int){
        val margin = JJScreen.pointW(20)
        when(gravity) {
            Gravity.END or Gravity.BOTTOM-> {
                JJLayout.clSetView(mTextDuration)
                        .clBottomToBottomParent(margin)
                        .clEndToEndParent(margin)
                        .clDisposeView()
            }
            Gravity.RIGHT or Gravity.BOTTOM-> {
                JJLayout.clSetView(mTextDuration)
                        .clBottomToBottomParent(margin)
                        .clEndToEndParent(margin)
                        .clDisposeView()
            }

            Gravity.START or Gravity.BOTTOM -> {
                JJLayout.clSetView(mTextDuration)
                        .clBottomToBottomParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.LEFT or Gravity.BOTTOM -> {
                JJLayout.clSetView(mTextDuration)
                        .clBottomToBottomParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.LEFT or Gravity.TOP -> {
                JJLayout.clSetView(mTextDuration)
                        .clTopToTopParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }

            Gravity.START or Gravity.TOP -> {
                JJLayout.clSetView(mTextDuration)
                        .clTopToTopParent(margin)
                        .clStartToStarParent(margin)
                        .clDisposeView()
            }
        }

    }

}