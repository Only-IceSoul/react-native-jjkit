package com.reactjjkit.views

import android.content.Context
import android.content.res.Resources
import android.graphics.*
import android.util.TypedValue
import android.view.View
import android.view.ViewOutlineProvider

import kotlin.math.min

class Badge(context: Context) : View(context) {

    private var mText = "99+"
    private var mIsTextHidden = false
    private var mTextOffsetX = 0f
    private var mTextOffsetY = 0f
    private val mPaintText = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mBadgePaintStroke = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mMaskPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private var mIsBitmapMask = true
    init { initBadge() }

    private fun initBadge() {
        mPaintText.color = Color.BLACK
        mPaintText.typeface = Typeface.DEFAULT
        mPaintText.textSize =  applyDimension(15f)
        mPaintText.textAlign = Paint.Align.CENTER
        mBadgePaintStroke.color = Color.BLACK
        mBadgePaintStroke.style = Paint.Style.STROKE
        mBadgePaintStroke.strokeWidth = 0f

        if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            mIsBitmapMask = false
            clipToOutline = true
            outlineProvider = object : ViewOutlineProvider() {
                override fun getOutline(view: View?, outline: Outline?) {
                    val radius = min(view!!.width, view.height) / 2f
                    outline?.setRoundRect(0, 0, view.width, view.height, radius)
                }
            }
        }
    }

    //region Badge set and get
    fun setBadgeStrokeColor(hex: String?) {
        val color = if(hex == null) Color.BLACK else  Color.parseColor(hex)
        mBadgePaintStroke.color = color
        invalidate()
    }

    fun setBadgeStrokeWidth(width: Float) {
        mBadgePaintStroke.strokeWidth = applyDimension(width,true)
        invalidate()
    }

    fun setText(text: String?) {
        mText = text ?: "99+"
        invalidate()
    }
    fun setTextSize(textSize: Float) {
        mPaintText.textSize = applyDimension(textSize)
        invalidate()
    }
    fun setTypeFace(font: String?) {
        val tf : Typeface = if(font != null) Typeface.createFromAsset(context.assets, "fonts/$font")
        else Typeface.DEFAULT
        mPaintText.typeface = tf
        invalidate()
    }
    private fun applyDimension(size: Float,isDp :Boolean = false): Float {
        val c = context
        val r = if (c == null) {
            Resources.getSystem()
        } else {
            c.resources
        }
        return if(isDp)   TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, size, r.displayMetrics)
        else TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, r.displayMetrics)
    }

    fun setTextColor(hex: String?) {
        val color = if(hex == null) Color.BLACK   else  Color.parseColor(hex)
        mPaintText.color = color
        invalidate()
    }

    fun setIsTextHidden(boolean: Boolean) {
        mIsTextHidden = boolean
        invalidate()
    }
    fun setTextOffsetX(value:Float){
        mTextOffsetX = value
        invalidate()
    }
    fun setTextOffsetY(value:Float){
        mTextOffsetY = value
        invalidate()
    }
    fun setInsetX(value:Float){ invalidate() }
    fun setInsetY(value:Float){ invalidate() }

    //endregion

    private var mDeltaY = 0f
    private var mDeltaX = 0f
    private val mBoundsText = Rect()
    private val mRectBadge = RectF()
    private val mRectMask = RectF()
    private var mBitmapMask: Bitmap? = null
    private var mCanvasMask: Canvas? = null
    private var mLastHeight = 0
    private var mLastWidth = 0
    override fun draw(canvas: Canvas?) {
        if (width > 0 && height > 0) {
            super.draw(canvas)
            drawText(canvas)
            drawStroke(canvas)
            if(mIsBitmapMask) drawBitmapMask(canvas)
        }
    }

    private fun drawText(canvas: Canvas?){
        mPaintText.getTextBounds(mText, 0, mText.length, mBoundsText)
        mDeltaY = (height shr 1 ) + mBoundsText.height() / 2f
        mDeltaX = (width shr 1).toFloat()
        val dy = mDeltaY + mTextOffsetY
        val dx = mDeltaX + mTextOffsetX
        if (!mIsTextHidden) canvas?.drawText(mText, dx, dy, mPaintText)
    }

    private fun drawStroke(canvas: Canvas?){
        if(mBadgePaintStroke.strokeWidth > 0) {
            mRectBadge.set(0f, 0f, width.toFloat(), height.toFloat())
            val radius = min(width, height).toFloat()
            val insetS = mBadgePaintStroke.strokeWidth / 2f
            mRectBadge.inset(insetS, insetS)
            canvas?.drawRoundRect(mRectBadge, radius, radius, mBadgePaintStroke)
        }
    }

    private fun drawBitmapMask(canvas: Canvas?){
        if(width != mLastWidth || height != mLastHeight) {
            mBitmapMask?.recycle()
            mBitmapMask = null
            mCanvasMask = null
            mBitmapMask = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            mCanvasMask = Canvas(mBitmapMask!!)
        }
        mLastHeight = height
        mLastWidth = width
        mRectMask.set(0f, 0f, width.toFloat(), height.toFloat())
        val radius = min(width, height).toFloat()
        mMaskPaint.color = Color.BLACK
        mCanvasMask?.drawRoundRect(mRectMask, radius, radius, mMaskPaint)
        setLayerType(LAYER_TYPE_HARDWARE, mMaskPaint)
        mMaskPaint.xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_IN)
        canvas?.drawBitmap(mBitmapMask!!, 0f, 0f, mMaskPaint)
        mMaskPaint.xfermode = null
    }
}