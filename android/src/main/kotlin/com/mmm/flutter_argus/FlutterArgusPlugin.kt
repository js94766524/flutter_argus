package com.mmm.flutter_argus

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Build
import android.os.LocaleList
import android.provider.Settings
import android.telephony.TelephonyManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*

class FlutterArgusPlugin(private val activity: Activity) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_argus")
            channel.setMethodCallHandler(FlutterArgusPlugin(registrar.activity()))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getInfo") {
            getAll().apply { result.success(this) }
        } else {
            result.notImplemented()
        }
    }

    private fun getAll(): Map<String, String> {
        val pkgInfo = getPackageInfo()
        val devInfo = getDeviceInfo()
        val otherInfo = getOtherInfo()
        return pkgInfo + devInfo + otherInfo
    }

    private fun getPackageInfo(): Map<String, String> {
        val pkgInfo = activity.packageManager.getPackageInfo(activity.packageName, 0)
        val pkn = pkgInfo.packageName
        val ver = pkgInfo.versionName
        val vcode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            pkgInfo.longVersionCode.toString()
        } else {
            pkgInfo.versionCode.toString()
        }
        return mapOf(
                "pkn" to pkn,
                "ver" to ver,
                "vcode" to vcode
        )
    }

    @SuppressLint("HardwareIds")
    private fun getDeviceInfo(): Map<String, String> {
        return mapOf(
                "osid" to Settings.Secure.getString(activity.contentResolver,"android_id"),
                "build_ts" to Build.TIME.toString(),
                "brand" to Build.BRAND,
                "model" to Build.MODEL,
                "mktname" to Build.MANUFACTURER,
                "device" to Build.DEVICE,
                "product" to Build.PRODUCT,
                "osver" to System.getProperty("os.version"),
                "osname" to System.getProperty("os.name"),
                "api" to Build.VERSION.SDK_INT.toString(),
                "lang" to Locale.getDefault().toString()
        )
    }

    private fun getOtherInfo(): Map<String, String> {
        val timezone = TimeZone.getDefault().id
        val mno = (activity.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager).networkOperator
        return mapOf(
                "timezone" to timezone,
                "mno" to mno
        )
    }
}
