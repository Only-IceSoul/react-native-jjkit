package com.reactjjkit.modules

import android.widget.Toast
import androidx.annotation.IntRange
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class ToastModule(context:ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    private val reactContext: ReactApplicationContext = context

    companion object{
       const val  DURATION_SHORT_KEY = "SHORT"
        const val DURATION_LONG_KEY = "LONG"
    }

    override fun getName(): String {
        return "Toast"
    }

    @ReactMethod
    fun show(message:String,@IntRange(from = 0, to = 1) length: Int){
        val duration = if(length > 1 || length < 0) Toast.LENGTH_SHORT else length
        Toast.makeText(reactContext,message,duration).show()
    }

    override fun getConstants(): MutableMap<String, Any> {
        return mutableMapOf(DURATION_SHORT_KEY to Toast.LENGTH_SHORT,
                DURATION_LONG_KEY to Toast.LENGTH_LONG)
    }

}