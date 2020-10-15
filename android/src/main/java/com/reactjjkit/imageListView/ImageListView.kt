@file:Suppress("UNCHECKED_CAST")

package com.reactjjkit.imageListView

import android.content.Context
import android.graphics.*
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.reactjjkit.layoutUtils.*

import java.lang.ref.WeakReference
import kotlin.Exception


class ImageListView(context: Context): ConstraintLayout(context),MediaAdapter.OnMediaItemClicked {

    companion object{
        const val EVENT_ON_END_REACHED = "onEndReached"
        const val EVENT_ON_ITEM_CLICKED = "onItemClicked"

    }

    private val mRecyclerView = RecyclerList(context)
    private lateinit var mAdapter :MediaAdapter


    @Suppress("UNCHECKED_CAST")
    fun source(data: ReadableMap?){
        val list = try { data!!.getArray("data")!!.toArrayList() }catch (e:Exception){ arrayListOf<Any>() }
        options(try{ data?.getMap("options") } catch (e:Exception){ null})
        resize(try{ data?.getMap("resize") } catch (e:Exception){ null})
        cell(try{data?.getMap("cell") } catch (e:Exception){ null})
        mAdapter.newData( (list as? ArrayList<HashMap<String,Any?>?>) )
        mRecyclerView.scrollToPosition(0)
    }


    private var mOrientation  = RecyclerView.VERTICAL
    private var mSpanCount = 3
    private var mThreshold = 2
    private var mIsSelectable = false
    private var mVideoIconVisible = true
    private var mVideoDurationVisible = true
    private var mSelectableColor = "#262626"
    private var mProgressVisible = false
    private var mProgressSize = 60
    private var mAllowGif = false
    private var mProgressColor = "#262626"
    private fun options(data: ReadableMap?){
        mSpanCount = try { data!!.getInt("spanCount") }catch(e: Exception) {  3 } //
        mOrientation = try { data!!.getInt("orientation") }catch(e: Exception) {  RecyclerView.VERTICAL }
        mIsSelectable = try { data!!.getBoolean("selectable") }catch(e: Exception) {  false } //
        mThreshold = try { data!!.getInt("threshold") }catch(e: Exception) {  2 } //
        mSelectableColor = try { data!!.getString("selectableColor")!! }catch(e: Exception) {  "#262626" }//
        mVideoIconVisible = try { data!!.getBoolean("videoIconVisible") }catch(e: Exception) {  true }
        mVideoDurationVisible = try { data!!.getBoolean("durationIconVisible") }catch(e: Exception) {  true }
        mProgressVisible = try { data!!.getBoolean("progressVisible") }catch(e: Exception) {  false }
        mProgressSize = try { data!!.getInt("progressSize") }catch(e: Exception) {  60 }
        mProgressColor = try { data!!.getString("progressColor")!! }catch(e: Exception) {  "#262626" }
        mAllowGif =  try { data!!.getBoolean("allowGif") }catch(e: Exception) {  false }

        val g =  (mRecyclerView.layoutManager as GridLayoutManager)
        g.spanCount = mSpanCount
        g.orientation = mOrientation
        mAdapter.isSelectable(mIsSelectable)
                .setSelectableColor(Color.parseColor(mSelectableColor))
                .setProgressColor(Color.parseColor(mProgressColor))
                .isVideoIconVisible(mVideoIconVisible)
                .isDurationIconVisible(mVideoDurationVisible)
                .isProgressVisible(mProgressVisible)
                .setProgressSize(mProgressSize)
                .setAllowGif(mAllowGif)
                .setOrientation(mOrientation)

    }

    private var mWidth = 300
    private var mHeight = 300
    private var mResizeMode = 0
    private fun resize(data:ReadableMap?){
        mWidth = try {  data!!.getInt("width") }catch(e: Exception) {  300 }
        mHeight = try { data!!.getInt("height") }catch(e: Exception) {  300 }
        mResizeMode = try {  data!!.getInt("mode") }catch(e: Exception) {  1 }

        mAdapter.setResizeOptions(mWidth,mHeight,mResizeMode)
    }




    private var mSize = JJScreen.width() / 3
    private var mBackgroundColor = "#cccccc"
    private var mMargin = JJMargin.all(2)
    private var mScaleType = 0 //cover

    private fun cell(data: ReadableMap?){
        var newSize = true
        mSize = try { data!!.getInt("size") }catch(e: Exception) {
            newSize = false
            JJScreen.width() / 3
        }
        mBackgroundColor = try { data!!.getString("backgroundColor")!! }catch(e: Exception) {  "#cccccc" }
        val l  = try {  data!!.getMap("margin")!!.getDouble("left") }catch(e: Exception) {  0 }
        val t  = try {  data!!.getMap("margin")!!.getDouble("top") }catch(e: Exception) {  0 }
        val r  = try {  data!!.getMap("margin")!!.getDouble("right") }catch(e: Exception) {  0 }
        val b  = try {  data!!.getMap("margin")!!.getDouble("bottom") }catch(e: Exception) {  0 }

        mMargin = JJMargin(
                JJScreen.dp(l.toFloat()).toInt(),
                JJScreen.dp(t.toFloat()).toInt(),
                JJScreen.dp(r.toFloat()).toInt(),
                JJScreen.dp(b.toFloat()).toInt()
        )
        mScaleType = try {  data!!.getInt("scaleType") }catch(e: Exception) {  1 }
        mAdapter.setCellOptions(if(newSize) JJScreen.dp(mSize.toFloat()).toInt() else mSize,Color.parseColor(mBackgroundColor),mScaleType)
        mMarginDecoration.setMargin(mMargin)

    }


    fun getSelectedItems(): List<HashMap<String,Any?>?>{
        val items = mAdapter.getItems()
        return  items.filter {
            if(it == null)  false
            else{
                it["isSelected"] as? Boolean ?: false
            }
        }
    }

    fun addItems(arr:ReadableArray?){
        val list = arr?.toArrayList() as? ArrayList<HashMap<String,Any?>?>
        val position =  mAdapter.itemCount - if(mProgressVisible) 2 else 1
         mAdapter.addItems(list)
        mRecyclerView.requestLayout()
    }


    private var mMarginDecoration = JJItemDecorationMargin(mMargin)

    init {

        val weak = weak()
        setBackgroundColor(Color.WHITE)
        mRecyclerView.id = View.generateViewId()
        addView(mRecyclerView)


        JJLayout.clSetView(mRecyclerView)
                .clFillParent()
                .clDisposeView()

        val grid = GridLayoutManager(context,mSpanCount,mOrientation,false)
        grid.spanSizeLookup = object : GridLayoutManager.SpanSizeLookup() {
            override fun getSpanSize(position: Int): Int {
                val t = weak.get()?.mAdapter?.getItemViewType(position) ?: 3
                val sc = weak.get()?.mSpanCount ?: 1

                return if(t == 2) sc else 1
            }

        }
        mRecyclerView.layoutManager = grid

        val reactContext = WeakReference(context as ReactContext)
        mAdapter = MediaAdapter(listener = this)

        mRecyclerView.addOnScrollListener(object: RecyclerView.OnScrollListener(){
            override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {
                super.onScrollStateChanged(recyclerView, newState)
                if((recyclerView.layoutManager as GridLayoutManager).findLastVisibleItemPosition() == recyclerView.adapter!!.itemCount - 1 && newState == RecyclerView.SCROLL_STATE_IDLE){
                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_END_REACHED, Arguments.createMap())
                }
            }
        })

        mRecyclerView.addItemDecoration(mMarginDecoration)
        mRecyclerView.adapter = mAdapter


    }

    override fun onItemClicked(item: HashMap<String, Any?>, view: PhotoCell?, activityResult: Boolean) {
       if(mIsSelectable) updateItemSelected(item,view)
        //send on item clicked
        val arg = Arguments.createMap()
        arg.putMap("item",Arguments.makeNativeMap(item))
        (context as ReactContext).getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_ITEM_CLICKED, arg)
    }

    override fun onItemClicked(item: HashMap<String, Any?>, view: VideoCell?, activityResult: Boolean) {
        if(mIsSelectable) updateItemSelected(item,view)
        //send on item clicked
        val arg = Arguments.createMap()
        arg.putMap("item",Arguments.makeNativeMap(item))
        (context as ReactContext).getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_ITEM_CLICKED, arg)
    }


    private fun updateItemSelected(item: HashMap<String, Any?>,view :SelectableView?){

        val items = mAdapter.getItems()
        val numbersSelection = items.count {
             if(it == null)  false
              else{
                 it["isSelected"] as? Boolean ?: false
             }

        }

        val st = item["isSelected"] as Boolean

        if (mThreshold > 1) {
            when {
                numbersSelection - 1 == 0 &&  st -> {
                    //all clean
                    item["isSelected"] = !st
                    view?.isSelected(!st)
                }
                numbersSelection < mThreshold - 1 || st -> {
                    item["isSelected"] = !st
                    view?.isSelected(!st)
                }
                numbersSelection == mThreshold - 1 -> {
                    //last select
                    item["isSelected"] = !st
                    view?.isSelected(!st)
                }
            }
        }else{
            when {
                numbersSelection == 0 -> {
                    //select
                    item["isSelected"] = !st
                    view?.isSelected(!st)
                }
                numbersSelection > 0 && st -> {
                    //unSelect
                    item["isSelected"] = !st
                    view?.isSelected(!st)
                }
            }
        }

    }





}