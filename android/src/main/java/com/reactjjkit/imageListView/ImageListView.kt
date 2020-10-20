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
import com.facebook.react.uimanager.PixelUtil
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

        mRecyclerView.post {
            mRecyclerView.scrollToPosition(0)
        }

    }




    private var mThreshold = 2
    private var mIsSelectable = false

    private fun options(data: ReadableMap?){
        val spanCount = try { data!!.getInt("spanCount") }catch(e: Exception) {  3 } //
        val orientation = try { data!!.getString("orientation")!! }catch(e: Exception) {  MediaAdapter.VERTICAL }
        mIsSelectable = try { data!!.getBoolean("selectable") }catch(e: Exception) {  false } //
        mThreshold = try { data!!.getInt("threshold") }catch(e: Exception) {  2 } //
        val selectableColor = try { data!!.getString("selectableColor")!! }catch(e: Exception) {  "#262626" }//
        val videoIconVisible = try { data!!.getBoolean("videoIconVisible") }catch(e: Exception) {  true }
        val durationVisible = try { data!!.getBoolean("durationVisible") }catch(e: Exception) {  true }
        val progressVisible = try { data!!.getBoolean("progressVisible") }catch(e: Exception) {  false }
        val progressSize = try { data!!.getDouble("progressSize").toFloat() }catch(e: Exception) {  60f }
        val progressColor = try { data!!.getString("progressColor")!! }catch(e: Exception) {  "#262626" }
        val allowGif =  try { data!!.getBoolean("allowGif") }catch(e: Exception) {  false }

        val durationTextSize = try { data!!.getDouble("durationTextSize").toFloat() } catch (e:Exception){ 11f }
        val videoIconSize =  try { data!!.getDouble("videoIconSize").toFloat() } catch (e:Exception){ 14f }
        val progressCellSize = try { data!!.getDouble("progressCellSize").toFloat() } catch (e:Exception){ 60f }
        val selectableIconSize  = try { data!!.getDouble("selectableIconSize").toFloat() } catch (e:Exception){ 11f }


        mLayoutManager.spanCount = spanCount
        mLayoutManager.orientation = if(orientation == MediaAdapter.HORIZONTAL ) RecyclerView.HORIZONTAL else RecyclerView.VERTICAL
        mAdapter.isSelectable(mIsSelectable)
                .setSelectableColor(Color.parseColor(selectableColor))
                .setProgressColor(Color.parseColor(progressColor))
                .isVideoIconVisible(videoIconVisible)
                .isDurationIconVisible(durationVisible)
                .isProgressVisible(progressVisible)
                .setAllowGif(allowGif)
                .setOrientation(orientation)
                .setProgressSize(JJScreen.dp(progressSize).toInt())
                .setProgressCellSize(JJScreen.dp(progressCellSize).toInt())
                .setDurationTextSize(durationTextSize)
                .setVideoIconSize(JJScreen.dp(videoIconSize).toInt())
                .setSelectableIconSize(JJScreen.dp(selectableIconSize).toInt())



    }

    private fun resize(data:ReadableMap?){
        val width = try {  data!!.getInt("width") }catch(e: Exception) {  300 }
        val height = try { data!!.getInt("height") }catch(e: Exception) {  300 }
        val resizeMode = try {  data!!.getString("mode")!! }catch(e: Exception) {  MediaAdapter.RESIZE_MODE_COVER }
        mAdapter.setResizeOptions(width,height,resizeMode)
    }

    private fun cell(data: ReadableMap?){
        var newSize = true
        val size = try { data!!.getDouble("size") }catch(e: Exception) {
            newSize = false
            JJScreen.width() / 3.0
        }
        val backgroundColor = try { data!!.getString("backgroundColor")!! }catch(e: Exception) {  "#cccccc" }
        val l  = try {  data!!.getMap("margin")!!.getDouble("left") }catch(e: Exception) {  0.0 }
        val t  = try {  data!!.getMap("margin")!!.getDouble("top") }catch(e: Exception) {  0.0 }
        val r  = try {  data!!.getMap("margin")!!.getDouble("right") }catch(e: Exception) {  0.0 }
        val b  = try {  data!!.getMap("margin")!!.getDouble("bottom") }catch(e: Exception) {  0.0 }

        val margin = JJMargin(
                JJScreen.dp(l.toFloat()).toInt(),
                JJScreen.dp(t.toFloat()).toInt(),
                JJScreen.dp(r.toFloat()).toInt(),
                JJScreen.dp(b.toFloat()).toInt()
        )
        val scaleType = try {  data!!.getString("scaleType")!! }catch(e: Exception) {  MediaAdapter.SCALE_TYPE_COVER }
        mAdapter.setCellOptions(if(newSize) JJScreen.dp(size.toFloat()).toInt() else size.toInt(),Color.parseColor(backgroundColor),scaleType)
        mMarginDecoration.setMargin(margin)

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
         mAdapter.addItems(list)
        mRecyclerView.post {
            mRecyclerView.requestLayout()
        }

    }


    private var mMarginDecoration = JJItemDecorationMargin(JJMargin())
    private var mLayoutManager: GridLayoutManager
    init {

        val weak = weak()
        setBackgroundColor(Color.WHITE)
        mRecyclerView.id = View.generateViewId()
        addView(mRecyclerView)


        JJLayout.clSetView(mRecyclerView)
                .clFillParent()
                .clDisposeView()

         mLayoutManager = GridLayoutManager(context,3,RecyclerView.VERTICAL,false)
        mLayoutManager.spanSizeLookup = object : GridLayoutManager.SpanSizeLookup() {
            override fun getSpanSize(position: Int): Int {
                val t = weak.get()?.mAdapter?.getItemViewType(position) ?: 3
                val sc = weak.get()?.mLayoutManager?.spanCount ?: 1

                return if(t == 2) sc else 1
            }

        }
        mRecyclerView.layoutManager = mLayoutManager

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