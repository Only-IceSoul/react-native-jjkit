package com.reactjjkit.shadowNodes


import android.graphics.Paint
import android.graphics.Rect
import android.graphics.Typeface
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.LayoutShadowNode
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.yoga.*
import com.reactjjkit.layoutUtils.JJScreen
import java.lang.ref.WeakReference


class BadgeShadowNode(context: ReactApplicationContext) : LayoutShadowNode(), YogaMeasureFunction {

    private var mText = "99+"
    private var mTextSize = 15f
    private var mFont = ""
    private var mInsetX = 0f
    private var mInsetY = 0f
    private var mContext = WeakReference(context)
    init { setMeasureFunction(this) }

    @ReactProp(name = "text")
    fun text(text: String?)  {
        mText = text ?: "99+"
        markUpdated()
    }

    @ReactProp(name = "textSize",defaultFloat = 15f)
    fun textSize(textSize: Float) {
        mTextSize = if(textSize < 0f) 0f else textSize
        markUpdated()
    }

    @ReactProp(name = "font")
    fun font(font: String?) {
        mFont = font ?: ""
    }

    @ReactProp(name = "insetX")
    fun insetX(value: Float)  {
        mInsetX = value / 100f
        markUpdated()
    }
    @ReactProp(name = "insetY")
    fun insetY(value: Float)  {
        mInsetY = value / 100f
        markUpdated()
    }


    override fun measure(node: YogaNode,
                         width: Float,
                         widthMode:YogaMeasureMode,
                         height: Float,
                         heightMode: YogaMeasureMode) : Long {
        computeWrapContentSize()
        val finalWidth = if(widthMode == YogaMeasureMode.AT_MOST || widthMode == YogaMeasureMode.UNDEFINED){
            mDesiredWidth
        } else width.toInt()
        val finalHeight = if(heightMode == YogaMeasureMode.AT_MOST || heightMode == YogaMeasureMode.UNDEFINED){
            mDesiredHeight
        } else height.toInt()

        return YogaMeasureOutput.make(finalWidth.toFloat(), finalHeight.toFloat())
    }


    private val mBoundsText = Rect()
    private val mPaintText = Paint(Paint.ANTI_ALIAS_FLAG)
    private var mDesiredWidth = 0
    private var mDesiredHeight = 0
    private fun computeWrapContentSize() {
        if (mText.isNotEmpty()) {
            val f = if (mFont.isEmpty()) Typeface.DEFAULT else Typeface.createFromAsset(mContext.get()!!.assets, "fonts/$mFont")
            mPaintText.typeface = f
            mPaintText.textSize = JJScreen.sp(mTextSize)
            mPaintText.getTextBounds(mText, 0, mText.length, mBoundsText)
            val iX = if (mText.length > 2) 0.55f + mInsetX else 0.65f + mInsetX
            val iY = 0.95f + mInsetY
            val fiX = if (iX < 0f) 0f else iX
            val fiY = if (iY < 0f) 0f else iY
            val marginH = mBoundsText.height()  * fiY
            val marginW = mBoundsText.width()  * fiX
            mDesiredWidth = mBoundsText.width() + marginW.toInt()
            mDesiredHeight = mBoundsText.height() + marginH.toInt()
            if (mText.length == 1) {
                mDesiredWidth = mDesiredHeight
            }
        }else {
            mDesiredWidth = 0
            mDesiredHeight = 0
        }
    }


    override fun markUpdated() {
        super.markUpdated()
        super.dirty()
    }

}