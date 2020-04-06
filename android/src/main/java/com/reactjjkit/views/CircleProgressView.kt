package com.reactjjkit.views

import android.content.Context
import android.graphics.*
import android.util.TypedValue
import android.view.View
import android.view.ViewGroup
import android.view.ViewOutlineProvider
import com.facebook.react.bridge.ReadableArray
import com.reactjjkit.extensions.flipMirror
import com.reactjjkit.extensions.rotation
import kotlin.math.min


class CircleProgressView(context: Context): ViewGroup(context) {

    private val mPaintBg = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        strokeWidth = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,4f,resources.displayMetrics)
        style = Paint.Style.STROKE
    }
    private val mPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        strokeWidth = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,4f,resources.displayMetrics)
        style = Paint.Style.STROKE
    }
    private var mColors = intArrayOf(
            Color.RED, Color.YELLOW, Color.GREEN,
            Color.CYAN, Color.BLUE, Color.MAGENTA, Color.RED)
    private var mPositionsColors: FloatArray? = null
    private var mBackColors = intArrayOf(Color.LTGRAY, Color.LTGRAY)
    private var mPositionsBackColors: FloatArray? = null

    private val mRect = RectF()
    private val mPathBg = Path()
    private val mPath = Path()
    private val mPathReverse = Path()
    private val mPathMeasure = PathMeasure()
    private var mProgress = 0f
    private val mMatrix = Matrix()

    init {
        clipToOutline = true
        outlineProvider = object: ViewOutlineProvider(){
            override fun getOutline(view: View?, outline: Outline?) {
                 val radius = min(view!!.width,view.height) / 2f
                outline?.setRoundRect(0,0,view.width,view.height,radius)
            }
        }
        setBackgroundColor(Color.TRANSPARENT)
    }

    fun setStrokeWidth(size:Float)  {
        val s = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,size,resources.displayMetrics)
        mPaint.strokeWidth = s
        mPaintBg.strokeWidth = s
        invalidate()
    }

    fun setColors(colors: ReadableArray?)  {
        val ca = intArrayOf(
                Color.RED, Color.YELLOW, Color.GREEN,
                Color.CYAN, Color.BLUE, Color.MAGENTA, Color.RED)

        val c = if(colors == null) ca else colorsStringToColors(colors)
        mColors = if(c.isEmpty()) ca else c
        mIsColorChanged = true
        invalidate()
    }
    fun setPositions(positions:ReadableArray?)  {
        val p = if(positions == null) null else arrayNumberToFloatArray(positions)
        mPositionsColors = p
        mIsColorChanged = true
        invalidate()
    }
    fun setBackColors(colors:ReadableArray?) {
        val ca = intArrayOf(Color.LTGRAY, Color.LTGRAY)
        val c = if(colors == null) ca else colorsStringToColors(colors)
        mBackColors = if(c.isEmpty()) ca else c
        mIsBackColorChanged = true
        invalidate()
    }
    fun setBackPositions(positions:ReadableArray?) {
        val p = if(positions == null) null else arrayNumberToFloatArray(positions)
        mPositionsBackColors = p
        mIsBackColorChanged = true
        invalidate()
    }

    fun setProgress(progress: Float)  {
        mProgress = progress
        invalidate()
    }

    fun setCap(cap: String?){
        val c = when(cap){
            "round" -> Paint.Cap.ROUND
            "square" -> Paint.Cap.SQUARE
            else -> Paint.Cap.BUTT
        }
        mPaintBg.strokeCap = c
        mPaint.strokeCap = c
        invalidate()
    }

    fun getProgress(): Float {
        return mProgress
    }

    override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {

    }


    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        setupRect()
        setupColor()
        setupBackColor()
        setupPathBg()

        mPathMeasure.setPath(mPathBg,false)

        mPath.reset()
        mPathMeasure.getSegment(0f,(mPathMeasure.length * mProgress),mPath,true)
        mPath.rLineTo(0.0f, 0.0f)

        mPathReverse.reset()
        val ps = if(mProgress < 0f) -mProgress else 0f
        mPathMeasure.getSegment(0f,(mPathMeasure.length * ps),mPathReverse,true)
        mPathReverse.rLineTo(0.0f, 0.0f)
        mPathReverse.flipMirror(vertical = false, horizontal = true, rect = mRect, ma = mMatrix)

        canvas?.drawPath(mPathBg,mPaintBg)
        canvas?.drawPath(mPath,mPaint)
        canvas?.drawPath(mPathReverse,mPaint)


    }
    private fun setupRect(){
        mRect.set(0f,0f,width.toFloat(),height.toFloat())
        val inset = mPaint.strokeWidth / 2
        mRect.inset(inset,inset)
    }

    private fun setupPathBg(){
        val radius = min(mRect.width(),mRect.height()) / 2f

        mPathBg.reset()
        mPathBg.addRoundRect(mRect,radius,radius,Path.Direction.CW)
        mPathBg.rotation(-90f,mRect,mMatrix)
    }

    private var mIsColorChanged = true
    private fun setupColor(){
        if(mIsColorChanged){
            mMatrix.reset()
            mMatrix.postRotate(-90f,mRect.centerX(),mRect.centerY())
            mPaint.shader = SweepGradient(mRect.centerX(),mRect.centerY(),mColors, mPositionsColors)
            mPaint.shader.setLocalMatrix(mMatrix)
            mIsColorChanged = false
        }
    }
    private var mIsBackColorChanged = true
    private fun setupBackColor(){
        if(mIsBackColorChanged){
            mMatrix.reset()
            mMatrix.postRotate(-90f,mRect.centerX(),mRect.centerY())
            mPaintBg.shader = SweepGradient(mRect.centerX(),mRect.centerY(),mBackColors,mPositionsBackColors)
            mPaintBg.shader.setLocalMatrix(mMatrix)
            mIsBackColorChanged = false
        }
    }


    private fun colorsStringToColors(colors:ReadableArray): IntArray{
        val list = mutableListOf<Int>()
        for(i in 0 until colors.size()){
            val c = Color.parseColor(colors.getString(i))
            list.add(c)
        }
        return list.toIntArray()
    }

    private fun arrayNumberToFloatArray(numbers:ReadableArray): FloatArray {
        val list = mutableListOf<Float>()
        for(i in 0 until numbers.size()){
            val c = numbers.getDouble(i).toFloat()
            list.add(c)
        }
        return list.toFloatArray()
    }
}