package com.reactjjkit.photoKit

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.core.app.ActivityCompat

class PermissionActivity : AppCompatActivity() {

    private lateinit var mMainView : View
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.enterTransition = null
        mMainView = View(this)
        setContentView(mMainView)

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            requestPermissions(arrayOf(
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE), 100)
        }

    }

    private fun checkPermission(permission: String):Boolean{
        return ActivityCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }

    private fun shouldShowRationale(permission:String): Boolean{
        var v = true
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) v = this.shouldShowRequestPermissionRationale(permission)
        return v
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 100) {
            if(permissions.isNotEmpty()){
                if (shouldShowRationale(permissions[0])) {
                    //deny
                    val i = Intent()
                    i.putExtra("status",0)
                    setResult(Activity.RESULT_OK,i)
                    finish()
                    overridePendingTransition(0,0)

                } else {
                    if (!checkPermission(permissions[0])) {
                        //never ask me
                        val i = Intent()
                        i.putExtra("status",2)
                        setResult(Activity.RESULT_OK,i)
                        finish()
                        overridePendingTransition(0,0)
                    }else{
                        //done
                        val i = Intent()
                        i.putExtra("status",1)
                        setResult(Activity.RESULT_OK,i)
                        finish()
                        overridePendingTransition(0,0)
                    }
                }
            }
        }


    }
}
