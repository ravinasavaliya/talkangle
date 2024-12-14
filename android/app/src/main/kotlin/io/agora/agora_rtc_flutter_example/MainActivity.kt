package com.talkangels.talkangels

import android.content.Context
import android.os.Bundle
import android.util.Log
//import io.agora.agora_rtc_flutter_example.VideoRawDataController
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.otpless.otplessflutter.OtplessFlutterPlugin;
import android.content.Intent;

class MainActivity: FlutterActivity() {


    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
        if (plugin is OtplessFlutterPlugin) {
            plugin.onNewIntent(intent)
        }
    }

    override fun onBackPressed() {
        val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
        if (plugin is OtplessFlutterPlugin) {
            if (plugin.onBackPressed()) return
        }
// handle other cases
        super.onBackPressed()
    }
    private lateinit var methodChannel: MethodChannel
    private lateinit var sharedNativeHandleMethodChannel: MethodChannel
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor, "agora_rtc_ng_example/foreground_service")
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start_foreground_service" -> {
                    ExampleService.startDaemonService(MainActivity@this.applicationContext)
                    result.success(true)
                }
                "stop_foreground_service" -> {
                    ExampleService.stopDaemonService(MainActivity@this.applicationContext)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        sharedNativeHandleMethodChannel = MethodChannel(flutterEngine.dartExecutor, "agora_rtc_engine_example/shared_native_handle")
        sharedNativeHandleMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "native_init" -> {
                    var nativeHandle = 0L
                    call.argument<String>("appId")?.apply {
                    }

                    result.success(nativeHandle)
                }
                "native_dispose" -> {
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun detachFromFlutterEngine() {
        super.detachFromFlutterEngine()


        methodChannel.setMethodCallHandler(null)
        sharedNativeHandleMethodChannel.setMethodCallHandler(null)
    }
}
