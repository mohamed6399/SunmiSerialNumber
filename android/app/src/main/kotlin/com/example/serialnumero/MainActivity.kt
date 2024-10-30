package com.example.serialnumero

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.yourapp/serial"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSerialNumber") {
                val serial = getSN()
                if (serial != null) {
                    result.success(serial)
                } else {
                    result.error("UNAVAILABLE", "Serial number not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSN(): String? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val c = Class.forName("android.os.SystemProperties")
                val get = c.getMethod("get", String::class.java)
                get.invoke(c, "ro.sunmi.serial") as String
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Build.getSerial()
            } else {
                Build.SERIAL
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}
