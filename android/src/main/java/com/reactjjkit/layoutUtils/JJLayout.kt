package com.reactjjkit.layoutUtils


import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.ConstraintSet

object JJLayout {


    //region ConstraintLayout

    private var mClView : View? = null

    fun clSetView(view:View): JJLayout{
        mClView = view
        return this
    }

    fun clDisposeView() : JJLayout{
        mClView = null
        return this
    }

    fun clAlpha(float:Float): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setAlpha(mClView!!.id,float)
        cs.applyTo(parentView)
        return this
    }

    fun clRotation(float: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setRotation(mClView!!.id,float)
        cs.applyTo(parentView)
        return this

    }

    fun clRotationX(float: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setRotationX(mClView!!.id,float)
        cs.applyTo(parentView)
        return this

    }

    fun clRotationY(float: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setRotationY(mClView!!.id,float)
        cs.applyTo(parentView)
        return this

    }

    fun clTranslation(x: Float,y: Float)  : JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTranslation(mClView!!.id,x,y)
        cs.applyTo(parentView)
        return this
    }
    fun clTranslationX(x: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTranslationX(mClView!!.id,x)
        cs.applyTo(parentView)
        return this
    }

    fun clTranslationY(y: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTranslationY(mClView!!.id,y)
        cs.applyTo(parentView)
        return this
    }

    fun clTranslationZ(z: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTranslationZ(mClView!!.id,z)
        cs.applyTo(parentView)
        return this
    }

    fun clTransformPivot(x: Float, y: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTransformPivot(mClView!!.id,x,y)
        cs.applyTo(parentView)
        return this
    }

    fun clTransformPivotX(x: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTransformPivotX(mClView!!.id,x)
        cs.applyTo(parentView)
        return this
    }

    fun clTransformPivotY(y: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setTransformPivotY(mClView!!.id,y)
        cs.applyTo(parentView)
        return this
    }

    fun clScaleX(x: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setScaleX(mClView!!.id,x)
        cs.applyTo(parentView)
        return this
    }

    fun clScaleY(y: Float) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setScaleY(mClView!!.id,y)
        cs.applyTo(parentView)
        return this
    }

    fun clDimensionRatio(ratio: String) : JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setDimensionRatio(mClView!!.id,ratio)
        cs.applyTo(parentView)
        return this
    }

    fun clFillParent( margin: JJMargin = JJMargin()): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainHeight(mClView!!.id,0)
        cs.constrainWidth(mClView!!.id,0)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin.top)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin.bottom)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin.left)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin.right)
        cs.applyTo(parentView)
        return this
    }

    fun clFillParentHorizontally( marginStart: Int = 0, marginEnd: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainWidth(mClView!!.id,0)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, marginStart)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, marginEnd)
        cs.applyTo(parentView)
        return this
    }

    fun clFillParentVertically( marginTop: Int = 0, marginBottom: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainHeight(mClView!!.id,0)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, marginTop)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, marginBottom)
        cs.applyTo(parentView)
        return this
    }


    fun clBottomToBottomParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clBottomToTopParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clTopToTopParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin)
        cs.applyTo(parentView)
        return this
    }


    fun clTopToBottomParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin)
        cs.applyTo(parentView)
        return this
    }


    fun clStartToStarParent( margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clStartToEndParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.END, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clEndToEndParent(margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clEndToStartParent( margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.START, margin)
        cs.applyTo(parentView)
        return this
    }


    fun clTopToBottomOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, viewOfId, ConstraintSet.BOTTOM, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clBottomToBottomOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, viewOfId, ConstraintSet.BOTTOM, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clTopToTopOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, viewOfId, ConstraintSet.TOP, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clBottomToTopOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, viewOfId, ConstraintSet.TOP, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clStartToStartOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, viewOfId, ConstraintSet.START, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clStartToEndOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, viewOfId, ConstraintSet.END, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clEndToEndOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.END, viewOfId, ConstraintSet.END, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clEndToStartOf( viewOfId: Int, margin: Int = 0): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.END, viewOfId, ConstraintSet.START, margin)
        cs.applyTo(parentView)
        return this
    }

    fun clVerticalBias( bias: Float): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setVerticalBias(mClView!!.id,bias)
        cs.applyTo(parentView)
        return this
    }

    fun clHorizontalBias( bias: Float): JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setHorizontalBias(mClView!!.id,bias)
        cs.applyTo(parentView)
        return this
    }


    fun clPercentWidth( width: Float): JJLayout {
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainPercentWidth(mClView!!.id, width)
        cs.applyTo(parentView)
        return this
    }

    fun clPercentHeight( height: Float) : JJLayout{
        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainPercentHeight(mClView!!.id, height)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParent() : JJLayout{

        val cs = ConstraintSet()
        val parentView =mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this

    }

    fun clCenterInParent( verticalBias: Float, horizontalBias: Float, margin: JJMargin): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin.left)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin.right)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin.top)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin.bottom)
        cs.setVerticalBias(mClView!!.id, verticalBias)
        cs.setHorizontalBias(mClView!!.id, horizontalBias)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParentVertically() : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this

    }

    fun clCenterInParentHorizontally()  : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParentVertically( bias: Float, topMargin: Int, bottomMargin: Int): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, topMargin)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, bottomMargin)
        cs.setVerticalBias(mClView!!.id, bias)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParentHorizontally( bias: Float, startMargin: Int, endMargin: Int) : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, startMargin)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, endMargin)
        cs.setHorizontalBias(mClView!!.id, bias)
        cs.applyTo(parentView)
        return this
    }


    fun clCenterInParentTopVertically() : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }


    fun clCenterInParentBottomVertically() : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParentStartHorizontally(): JJLayout  {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInParentEndHorizontally()  : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInTopVerticallyOf( topId: Int) : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, topId, ConstraintSet.TOP, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, topId, ConstraintSet.TOP, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }


    fun clCenterInBottomVerticallyOf( bottomId: Int) : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.TOP, bottomId, ConstraintSet.BOTTOM, 0)
        cs.connect(mClView!!.id, ConstraintSet.BOTTOM, bottomId, ConstraintSet.BOTTOM, 0)
        cs.setVerticalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInStartHorizontallyOf( startId: Int) : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, startId, ConstraintSet.START, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, startId, ConstraintSet.START, 0)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }

    fun clCenterInEndHorizontallyOf( endId: Int)  : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.connect(mClView!!.id, ConstraintSet.START, endId, ConstraintSet.END, 0)
        cs.connect(mClView!!.id, ConstraintSet.END, endId, ConstraintSet.END, 0)
        cs.setHorizontalBias(mClView!!.id, 0.5f)
        cs.applyTo(parentView)
        return this
    }


    fun clVisibility( visibility: Int): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setVisibility(mClView!!.id, visibility)
        cs.applyTo(parentView)
        return this
    }



    fun clElevation( elevation: Float): JJLayout  {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setElevation(mClView!!.id, elevation)
        cs.applyTo(parentView)
        return this
    }


    fun clMinWidth( w:Int): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainMinWidth(mClView!!.id,w)
        cs.applyTo(parentView)
        return this
    }

    fun clMinHeight( h:Int) : JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainMinHeight(mClView!!.id,h)
        cs.applyTo(parentView)
        return this
    }

    fun clMaxWidth( w:Int): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainMaxWidth(mClView!!.id,w)
        cs.applyTo(parentView)
        return this
    }

    fun clMaxHeight( h:Int) : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainMaxHeight(mClView!!.id,h)
        cs.applyTo(parentView)
        return this
    }


    fun clWidth( width: Int): JJLayout {
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainWidth(mClView!!.id, width)
        cs.applyTo(parentView)
        return this
    }

    fun clHeight( height: Int) : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.constrainHeight(mClView!!.id, height)
        cs.applyTo(parentView)
        return this
    }

    fun clMargins( margins: JJMargin)  : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setMargin(mClView!!.id,ConstraintSet.TOP,margins.top)
        cs.setMargin(mClView!!.id,ConstraintSet.BOTTOM,margins.bottom)
        cs.setMargin(mClView!!.id,ConstraintSet.END,margins.right)
        cs.setMargin(mClView!!.id,ConstraintSet.START,margins.left)
        cs.applyTo(parentView)
        return this
    }

    fun clVisibilityMode( visibility: Int) : JJLayout{
        val cs = ConstraintSet()
        val parentView = mClView!!.parent as ConstraintLayout
        cs.clone(parentView)
        cs.setVisibilityMode(mClView!!.id, visibility)
        cs.applyTo(parentView)
        return this
    }

    //endregion


    //region MotionLayout Params

    private var mMotionConstraintSet: ConstraintSet? = null

    private var mMotionView : View? = null

    fun mlSetView(view:View){
        mMotionView = view
    }

    fun mlDisposeView(){
        mMotionView = null
    }

    fun mlVisibilityMode(visibility: Int)  {
        mMotionConstraintSet?.setVisibilityMode(mMotionView!!.id, visibility)

    }

    fun mlVerticalBias(float: Float)  {
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id,float)

    }
    fun mlHorizontalBias(float: Float)  {
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id,float)

    }

    fun mlCenterHorizontallyOf(viewId: Int, marginStart: Int = 0, marginEnd: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, viewId, ConstraintSet.START, marginStart)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, viewId, ConstraintSet.END, marginEnd)
        mMotionConstraintSet?.setHorizontalBias(viewId,0.5f)

    }
    fun mlCenterVerticallyOf(viewId: Int,marginTop: Int = 0, marginBottom: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, viewId, ConstraintSet.TOP, marginTop)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, viewId, ConstraintSet.BOTTOM, marginBottom)
        mMotionConstraintSet?.setVerticalBias(viewId,0.5f)

    }

    fun mlMargins(margins: JJMargin)  {
        mMotionConstraintSet?.setMargin(mMotionView!!.id,ConstraintSet.TOP,margins.top)
        mMotionConstraintSet?.setMargin(mMotionView!!.id,ConstraintSet.BOTTOM,margins.bottom)
        mMotionConstraintSet?.setMargin(mMotionView!!.id,ConstraintSet.END,margins.right)
        mMotionConstraintSet?.setMargin(mMotionView!!.id,ConstraintSet.START,margins.left)

    }


    fun mlFloatCustomAttribute(attrName: String, value: Float)  {
        mMotionConstraintSet?.setFloatValue(mMotionView!!.id,attrName,value)

    }

    fun mlIntCustomAttribute(attrName: String, value: Int)  {
        mMotionConstraintSet?.setIntValue(mMotionView!!.id,attrName,value)

    }

    fun mlColorCustomAttribute(attrName: String, value: Int)  {
        mMotionConstraintSet?.setColorValue(mMotionView!!.id,attrName,value)

    }

    fun mlStringCustomAttribute(attrName: String, value: String)  {
        mMotionConstraintSet?.setStringValue(mMotionView!!.id,attrName,value)

    }

    fun mlRotation(float: Float)  {
        mMotionConstraintSet?.setRotation(mMotionView!!.id,float)

    }

    fun mlRotationX(float: Float)  {
        mMotionConstraintSet?.setRotationX(mMotionView!!.id,float)

    }

    fun mlRotationY(float: Float)  {
        mMotionConstraintSet?.setRotationY(mMotionView!!.id,float)

    }

    fun mlTranslation(x: Float,y: Float)  {
        mMotionConstraintSet?.setTranslation(mMotionView!!.id,x,y)

    }
    fun mlTranslationX(x: Float)  {
        mMotionConstraintSet?.setTranslationX(mMotionView!!.id,x)

    }

    fun mlTranslationY(y: Float)  {
        mMotionConstraintSet?.setTranslationY(mMotionView!!.id,y)

    }

    fun mlTranslationZ(z: Float)  {
        mMotionConstraintSet?.setTranslationZ(mMotionView!!.id,z)

    }

    fun mlTransformPivot(x: Float, y: Float)  {
        mMotionConstraintSet?.setTransformPivot(mMotionView!!.id,x,y)

    }

    fun mlTransformPivotX(x: Float)  {
        mMotionConstraintSet?.setTransformPivotX(mMotionView!!.id,x)

    }

    fun mlTransformPivotY(y: Float)  {
        mMotionConstraintSet?.setTransformPivotY(mMotionView!!.id,y)

    }

    fun mlScaleX(x: Float)  {
        mMotionConstraintSet?.setScaleX(mMotionView!!.id,x)

    }

    fun mlScaleY(y: Float)  {
        mMotionConstraintSet?.setScaleY(mMotionView!!.id,y)

    }

    fun mlDimensionRatio(ratio: String)  {
        mMotionConstraintSet?.setDimensionRatio(mMotionView!!.id,ratio)

    }

    fun mlAlpha(alpha: Float)  {
        mMotionConstraintSet?.setAlpha(mMotionView!!.id,alpha)

    }



    fun mlTopToTop(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, viewId, ConstraintSet.TOP, margin)

    }

    fun mlTopToTopParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin)

    }


    fun mlTopToBottomOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, viewId, ConstraintSet.BOTTOM, margin)

    }

    fun mlTopToBottomParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin)

    }

    fun mlBottomToTopOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, viewId, ConstraintSet.TOP, margin)


    }

    fun mlBottomToTopParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin)


    }

    fun mlBottomToBottomOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, viewId, ConstraintSet.BOTTOM, margin)


    }

    fun mlBottomToBottomParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin)


    }

    fun mlStartToStartOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, viewId, ConstraintSet.START, margin)


    }

    fun mlStartToStartParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin)


    }

    fun mlStartToEndOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, viewId, ConstraintSet.END, margin)


    }

    fun mlStartToEndParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.END, margin)


    }

    fun mlEndToEndOf(viewId: Int, margin: Int= 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, viewId, ConstraintSet.END, margin)


    }

    fun mlEndToEndParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin)


    }


    fun mlEndToStartOf(viewId: Int, margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, viewId, ConstraintSet.START, margin)

    }

    fun mlEndToStartParent(margin: Int = 0)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.START, margin)

    }


    fun mlWidth(width: Int)  {
        mMotionConstraintSet?.constrainWidth(mMotionView!!.id, width)

    }

    fun mlHeight(height: Int)  {
        mMotionConstraintSet?.constrainHeight(mMotionView!!.id, height)

    }

    fun mlPercentWidth(width: Float)  {
        mMotionConstraintSet?.constrainPercentWidth(mMotionView!!.id, width)

    }

    fun mlPercentHeight(height: Float)  {
        mMotionConstraintSet?.constrainPercentHeight(mMotionView!!.id, height)

    }

    fun mlCenterInParent()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)


    }

    fun mlCenterInParent(verticalBias: Float, horizontalBias: Float, margin: JJMargin)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin.left)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin.right)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin.top)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin.bottom)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, verticalBias)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, horizontalBias)

    }

    fun mlCenterInParentVertically()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)


    }

    fun mlCenterInParentHorizontally()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInParentVertically(bias: Float, topMargin: Int, bottomMargin: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, topMargin)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, bottomMargin)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, bias)

    }

    fun mlCenterInParentHorizontally(bias: Float, startMargin: Int, endtMargin: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, startMargin)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, endtMargin)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, bias)

    }


    fun mlCenterInParentTopVertically()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)

    }


    fun mlCenterInParentBottomVertically()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInParentStartHorizontally()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInParentEndHorizontally()  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInTopVerticallyOf(viewId: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, viewId, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, viewId, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)

    }


    fun mlCenterInBottomVerticallyOf(viewId: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, viewId, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, viewId, ConstraintSet.BOTTOM, 0)
        mMotionConstraintSet?.setVerticalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInStartHorizontallyOf(viewId: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, viewId, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, viewId, ConstraintSet.START, 0)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterInEndHorizontallyOf(viewId: Int)  {
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, viewId, ConstraintSet.END, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, viewId, ConstraintSet.END, 0)
        mMotionConstraintSet?.setHorizontalBias(mMotionView!!.id, 0.5f)

    }

    fun mlCenterVertically(topId: Int, topSide: Int, topMargin: Int, bottomId: Int, bottomSide: Int, bottomMargin: Int, bias: Float)  {
        mMotionConstraintSet?.centerVertically(mMotionView!!.id, topId, topSide, topMargin, bottomId, bottomSide, bottomMargin, bias)

    }

    fun mlCenterHorizontally(startId: Int, startSide: Int, startMargin: Int, endId: Int, endSide: Int, endMargin: Int, bias: Float)  {
        mMotionConstraintSet?.centerHorizontally(mMotionView!!.id, startId, startSide, startMargin, endId, endSide, endMargin, bias)

    }


    fun mlFillParent()  {
        mMotionConstraintSet?.constrainHeight(mMotionView!!.id,0)
        mMotionConstraintSet?.constrainWidth(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)

    }

    fun mlFillParent(margin: JJMargin)  {
        mMotionConstraintSet?.constrainHeight(mMotionView!!.id,0)
        mMotionConstraintSet?.constrainWidth(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, margin.top)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, margin.left)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, margin.right)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, margin.bottom)

    }

    fun mlFillParentHorizontally()  {
        mMotionConstraintSet?.constrainWidth(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, 0)

    }

    fun mlFillParentVertically()  {
        mMotionConstraintSet?.constrainHeight(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, 0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, 0)

    }

    fun mlFillParentHorizontally(startMargin: Int, endMargin: Int)  {
        mMotionConstraintSet?.constrainWidth(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START, startMargin)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END, endMargin)

    }

    fun mlFillParentVertically(topMargin: Int, bottomMargin: Int)  {
        mMotionConstraintSet?.constrainHeight(mMotionView!!.id,0)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP, topMargin)
        mMotionConstraintSet?.connect(mMotionView!!.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM, bottomMargin)

    }

    fun mlVisibility(visibility: Int)  {
        mMotionConstraintSet?.setVisibility(mMotionView!!.id, visibility)

    }

    fun mlElevation(elevation: Float)  {
        mMotionConstraintSet?.setElevation(mMotionView!!.id, elevation)

    }

    fun mlApply()  {
        mMotionConstraintSet?.applyTo(mMotionView!!.parent as ConstraintLayout)

    }

    fun mlSetConstraint(cs : ConstraintSet?)  {
        mMotionConstraintSet = cs

    }

    fun mlDisposeConstraint()  {
        mMotionConstraintSet = null

    }

    //endregion


}