@file:Suppress("UNCHECKED_CAST")

package com.reactjjkit.imageListView

import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import java.lang.Exception


import java.lang.ref.WeakReference


class MediaAdapter(list: ArrayList<HashMap<String,Any?>?> = ArrayList(), listener: OnMediaItemClicked) : RecyclerView.Adapter<RecyclerView.ViewHolder>(){
    private var mItems = list
    private var mListenerClick : WeakReference<OnMediaItemClicked> = WeakReference(listener)

    private var mSelectableColor =  Color.parseColor("#262626")
    private var mProgressColor = Color.parseColor("#262626")
    private var mIsVideoDurationVisible = true
    private var mIsVideoIconVisible = true
    private var mIsSelectable = false

    private var mVideoDurationGravity = Gravity.END or Gravity.BOTTOM
    private var mVideoIconGravity = Gravity.START or Gravity.BOTTOM
    private var mPreviewGravity = Gravity.START or Gravity.TOP

    private var mShowProgressView = false
    private var mBackgroundColorView = Color.WHITE

    private var mScaleType = 0

    private var mSizeProgress = 60f
    fun setProgressSize(dp: Int) : MediaAdapter {
        mSizeProgress = dp.toFloat()
        return this
    }
    fun isProgressVisible(boolean: Boolean) : MediaAdapter {
        mShowProgressView = boolean
        return this
    }
    fun setSelectableColor(color: Int): MediaAdapter{
        mSelectableColor = color
        return this
    }
    fun setProgressColor(color: Int): MediaAdapter{
        mProgressColor = color
        return this
    }



    fun isDurationIconVisible(boolean: Boolean) : MediaAdapter {
        mIsVideoDurationVisible = boolean
        return this
    }

    fun setVideoDurationGravity(gravity: Int) : MediaAdapter {
        mVideoDurationGravity = gravity
        return this
    }
    fun setIconPreviewGravity(gravity: Int) : MediaAdapter {
        mPreviewGravity = gravity
        return this
    }

    fun setVideoIconGravity(gravity: Int) : MediaAdapter {
        mVideoIconGravity = gravity
        return this
    }

    fun isVideoIconVisible(boolean: Boolean) : MediaAdapter {
        mIsVideoIconVisible = boolean
        return this
    }



    fun isSelectable(boolean: Boolean): MediaAdapter{
        mIsSelectable = boolean
        return this
    }

    fun setAllowGif(boolean: Boolean): MediaAdapter{
        mAllowGif = boolean
        return this
    }

    fun setOrientation(orientation: Int): MediaAdapter{
        mOrientation = orientation
        return this
    }




    private var mWidth = 300
    private var mHeight = 300
    private var mResizeMode = 1
    private var mAllowGif = false
    private var mOrientation = RecyclerView.VERTICAL
    private var mSize = 0



    fun setResizeOptions(w:Int, h:Int, rm : Int): MediaAdapter{
        mWidth = w
        mHeight = h
        mResizeMode = rm
        return this
    }


    fun setCellOptions(size:Int, bgColor:Int,st:Int): MediaAdapter{
        mSize = size
        mBackgroundColorView = bgColor
        mScaleType = st
        return this
    }


    override fun getItemViewType(position: Int): Int {
        return when(try{ (mItems[position]!!["mediaType"] as String )} catch (e:Exception) {"image"}){
            "image" -> 0
            "video" -> 1
            "progress"-> 2
            else -> 3
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {

        val v : View = when(viewType) {
             0 -> PhotoCell(parent.context,mSelectableColor,mPreviewGravity)
             2 -> ProgressView(parent.context,mSizeProgress)
             1 -> VideoCell(parent.context,mSelectableColor,mVideoDurationGravity,mVideoIconGravity,mPreviewGravity)
            else -> View(parent.context)
        }

        v.layoutParams = if(mOrientation == RecyclerView.VERTICAL)  ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                mSize
        ) else  ViewGroup.LayoutParams(
                mSize,
                ViewGroup.LayoutParams.MATCH_PARENT
        )

      return  when (v) {
            is PhotoCell -> {
                v.isIconSelectionVisible(mIsSelectable)
                ViewHolderPhoto(v)
            }
            is VideoCell -> {
                v.isDurationVisible(mIsVideoDurationVisible)
                v.isIconVisible(mIsVideoIconVisible)
                v.isIconSelectionVisible(mIsSelectable)
                ViewHolderVideo(v)
            }
            is ProgressView ->{
                val size = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,mSizeProgress,parent.context.resources.displayMetrics).toInt()
                v.layoutParams = if(mOrientation == RecyclerView.VERTICAL)  ViewGroup.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        size
                ) else  ViewGroup.LayoutParams(
                        size,
                        ViewGroup.LayoutParams.MATCH_PARENT
                )
                ProgressHolder(v)
            }
            else -> {
                   BlankHolder(View(parent.context))
            }
        }


    }



    override fun getItemCount(): Int {
        return mItems.size
    }


    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val item = mItems[position]

        item?.let { i ->

            if(!i.containsKey("isSelected")){
                i["isSelected"] = false
            }
            if(!i.containsKey("mediaType")){
                i["mediaType"] = "image"
            }
            if(!i.containsKey("isEnabled")){
                i["isEnabled"] = true
            }

            var g  = if(i["mediaType"] as String == "gif" && mAllowGif) Glide.with(holder.itemView).asGif() else Glide.with(holder.itemView).asBitmap()
            if(mWidth > 0 && mHeight > 0) g = if(mResizeMode == 1) g.centerCrop().override(mWidth,mHeight) else g.fitCenter().override(mWidth,mHeight)
            g = g.frame(0L)


            if(holder is ViewHolderPhoto) {
                val view = holder.view
                view.getImageView().scaleType = if(mScaleType == 1) ImageView.ScaleType.CENTER_CROP else ImageView.ScaleType.FIT_CENTER
                view.setBackgroundColor(mBackgroundColorView)

                g.load(i["uri"] as? String).into(view.getImageView())
                view.setOnClickListener {
                    mListenerClick.get()?.onItemClicked(item, view)
                }

                if (i["isEnabled"] as? Boolean == true) {
                    view.alpha = 1.0f
                    view.isEnabled = true
                } else {
                    view.alpha = 0.3f
                    view.isEnabled = false
                }

                view.isSelected(i["isSelected"] as? Boolean ?: false)

            }
            if (holder is ViewHolderVideo){
                val view = holder.view
                view.setBackgroundColor(mBackgroundColorView)
                view.getImageView().scaleType = if(mScaleType == 1) ImageView.ScaleType.FIT_CENTER else ImageView.ScaleType.CENTER_CROP

                g.load(i["uri"] as? String).into(view.getImageView())

                view.setOnClickListener {
                    mListenerClick.get()?.onItemClicked(item,view)
                }

                if (i["isEnabled"] as? Boolean == true)  {
                    view.alpha = 1.0f
                    view.isEnabled = true
                } else {
                    view.alpha = 0.3f
                    view.isEnabled = false
                }


                view.isSelected(i["isSelected"] as? Boolean ?: false)
                view.setTextDuration(( (i["duration"] as? Double ?: 0.0) * 1000).toLong() )

            }
            if(holder is ProgressHolder){
                val v = holder.view
                v.setProgressColor(mProgressColor)
            }
        }

    }


    fun newData(list: ArrayList<HashMap<String,Any?>?>?){
        val l = list ?: arrayListOf()
        if(mShowProgressView && l.isNotEmpty()){
            val m = mapOf<String,Any>("mediaType" to "progress")
            l.add(HashMap(m))
        }
        mItems = l
        notifyDataSetChanged()

    }

    fun addItems(list: ArrayList<HashMap<String,Any?>?>?){
        Handler(Looper.getMainLooper()).post {
            removeProgress()
            if(!list.isNullOrEmpty()) {
                if(mShowProgressView){
                    val m = mapOf<String,Any>("mediaType" to "progress")
                    list.add(HashMap(m))
                }
                val posStart = mItems.size
                mItems.addAll(list)
                notifyItemRangeInserted(posStart, list.size)
            }
        }

    }

    private fun removeProgress() {
        val position = mItems.size - 1
        val i = mItems[position]
        if(position >= 0 && i != null) {
            if ((i["mediaType"] as? String ?: "") == "progress") {
                mItems.removeAt(position)
                notifyItemRemoved(position)
            }
        }
    }

    fun getItems() : ArrayList<HashMap<String,Any?>?>{
        return mItems
    }

    interface OnMediaItemClicked {
        fun onItemClicked(item: HashMap<String,Any?>, view: PhotoCell?,activityResult: Boolean = false)
        fun onItemClicked(item: HashMap<String,Any?>, view: VideoCell?, activityResult: Boolean = false)
    }

    class ViewHolderPhoto(var view: PhotoCell) : RecyclerView.ViewHolder(view)
    class ViewHolderVideo(var view: VideoCell) : RecyclerView.ViewHolder(view)
    class ProgressHolder(var view: ProgressView) : RecyclerView.ViewHolder(view)

    class BlankHolder(var view: View) : RecyclerView.ViewHolder(view)
}