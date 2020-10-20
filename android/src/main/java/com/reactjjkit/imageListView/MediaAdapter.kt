@file:Suppress("UNCHECKED_CAST")

package com.reactjjkit.imageListView

import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.reactjjkit.layoutUtils.JJScreen
import java.lang.Exception


import java.lang.ref.WeakReference


class MediaAdapter(list: ArrayList<HashMap<String,Any?>?> = ArrayList(), listener: OnMediaItemClicked) : RecyclerView.Adapter<RecyclerView.ViewHolder>(){

    companion object{
        const val TYPE_GIF = "gif"
        const val TYPE_IMAGE = "image"
        const val TYPE_VIDEO = "video"
        const val TYPE_PROGRESS = "progress"
        const val RESIZE_MODE_CONTAIN = "contain"
        const val RESIZE_MODE_COVER = "cover"
        const val VERTICAL = "vertical"
        const val HORIZONTAL = "horizontal"
        const val SCALE_TYPE_CONTAIN = "contain"
        const val SCALE_TYPE_COVER = "cover"
    }

    private var mItems = list
    private var mListenerClick : WeakReference<OnMediaItemClicked> = WeakReference(listener)

    private var mSelectableColor =  Color.parseColor("#262626")
    private var mProgressColor = Color.parseColor("#262626")
    private var mIsVideoDurationVisible = true
    private var mIsVideoIconVisible = true
    private var mIsSelectable = false

    private var mVideoDurationGravity = Gravity.END or Gravity.BOTTOM
    private var mVideoIconGravity = Gravity.START or Gravity.BOTTOM


    private var mShowProgressView = false
    private var mBackgroundColorView = Color.WHITE

    private var mScaleType = SCALE_TYPE_CONTAIN

    private var mProgressSize = JJScreen.dp(60f).toInt()
    fun setProgressSize(pixel: Int) : MediaAdapter {
        mProgressSize = pixel
        return this
    }

    private var mProgressCellSize = JJScreen.dp(60f).toInt()
    fun setProgressCellSize(pixel: Int) : MediaAdapter {
        mProgressCellSize = pixel
        return this
    }

    private var mDurationTextSize = 11f
    fun setDurationTextSize(sp: Float) : MediaAdapter {
        mDurationTextSize = sp
        return this
    }
    private var mVideoIconSize = JJScreen.dp(14f).toInt()
    fun setVideoIconSize(pixel: Int) : MediaAdapter {
        mVideoIconSize = pixel
        return this
    }

    private var mSelectableIconSize = JJScreen.dp(11f).toInt()
    fun setSelectableIconSize(pixel: Int) : MediaAdapter {
        mSelectableIconSize = pixel
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

    fun setOrientation(orientation: String): MediaAdapter{
        mOrientation = orientation
        return this
    }




    private var mWidth = 300
    private var mHeight = 300
    private var mResizeMode = RESIZE_MODE_CONTAIN
    private var mAllowGif = false
    private var mOrientation = VERTICAL
    private var mSize = 0



    fun setResizeOptions(w:Int, h:Int, rm : String): MediaAdapter{
        mWidth = w
        mHeight = h
        mResizeMode = rm
        return this
    }


    fun setCellOptions(size:Int, bgColor:Int,st:String): MediaAdapter{
        mSize = size
        mBackgroundColorView = bgColor
        mScaleType = st
        return this
    }


    override fun getItemViewType(position: Int): Int {
        return when(try{ (mItems[position]!!["mediaType"] as String )} catch (e:Exception) {TYPE_IMAGE}){
           TYPE_IMAGE -> 0
            TYPE_GIF -> 0
            TYPE_VIDEO -> 1
            TYPE_PROGRESS -> 2
            else -> 3
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {

        val v : View = when(viewType) {
             0 -> PhotoCell(parent.context,mSelectableColor,mSelectableIconSize)
             2 -> ProgressView(parent.context,mProgressSize)
             1 -> VideoCell(parent.context,mSelectableColor,mSelectableIconSize,mVideoIconSize,mDurationTextSize)
            else -> View(parent.context)
        }

        v.layoutParams = if(mOrientation == VERTICAL)  ViewGroup.LayoutParams(
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
                v.layoutParams = if(mOrientation == VERTICAL)  ViewGroup.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        mProgressCellSize
                ) else  ViewGroup.LayoutParams(
                        mProgressCellSize,
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
                i["mediaType"] = TYPE_IMAGE
            }
            if(!i.containsKey("isEnabled")){
                i["isEnabled"] = true
            }

            var g  = if(i["mediaType"] as String == "gif" && mAllowGif) Glide.with(holder.itemView).asGif() else Glide.with(holder.itemView).asBitmap()
            if(mWidth > 0 && mHeight > 0 && !mAllowGif) g = if(mResizeMode == RESIZE_MODE_CONTAIN) g.fitCenter().override(mWidth,mHeight) else g.centerCrop().override(mWidth,mHeight)
            if(!mAllowGif) g = g.frame(0L)


            if(holder is ViewHolderPhoto) {
                val view = holder.view
                view.getImageView().scaleType = if(mScaleType == SCALE_TYPE_CONTAIN) ImageView.ScaleType.FIT_CENTER else ImageView.ScaleType.CENTER_CROP
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
                view.getImageView().scaleType = if(mScaleType == SCALE_TYPE_CONTAIN) ImageView.ScaleType.FIT_CENTER else ImageView.ScaleType.CENTER_CROP

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
            val m = mapOf<String,Any>("mediaType" to TYPE_PROGRESS)
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
                    val m = mapOf<String,Any>("mediaType" to TYPE_PROGRESS)
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
            if ((i["mediaType"] as? String ?: "") == TYPE_PROGRESS) {
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