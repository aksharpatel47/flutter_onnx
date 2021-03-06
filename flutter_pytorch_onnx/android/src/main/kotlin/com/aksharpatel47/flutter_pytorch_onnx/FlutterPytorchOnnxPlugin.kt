package com.aksharpatel47.flutter_pytorch_onnx

import android.content.res.AssetManager
import android.util.Log
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.pytorch.IValue
import org.pytorch.Module
import org.pytorch.Tensor
import java.io.File
import java.nio.charset.Charset

/** FlutterPytorchOnnxPlugin */
public class FlutterPytorchOnnxPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var flutterAssets: FlutterPlugin.FlutterAssets
  private lateinit var assetManager: AssetManager
  private lateinit var module: Module
  private lateinit var moduleClasses: List<String>

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pytorch_onnx")
    channel.setMethodCallHandler(this)
    flutterAssets = flutterPluginBinding.flutterAssets
    assetManager = flutterPluginBinding.applicationContext.assets
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "loadModule" -> {
        try {
          val arguments = call.arguments as List<*>
          val assetPath = arguments.first() as String
          module = Module.load(assetPath)
          Log.d("loadModule", "onMethodCall: Module Loaded")
          result.success(true)
        } catch (e: Exception) {
          Log.d("loadModule", e.message!!)
          result.error("1", e.message, null)
        }
      }
      "getModuleClasses" -> {
        val classesOutput = module.runMethod("get_classes")
        val classesListIValue = classesOutput.toList()
        moduleClasses = classesListIValue.asList().map { a -> a.toStr() }
        result.success(moduleClasses)
      }
      "analyzeText" -> {
        val arguments = call.arguments as List<*>
        val text = arguments.first() as String
        val bytes = text.toByteArray(Charset.forName("UTF-8"))
        val shape = longArrayOf(1, bytes.size.toLong())
        val inputTensor = Tensor.fromBlobUnsigned(bytes, shape)
        val outputTensor = module.forward(IValue.from(inputTensor)).toTensor()
        val scores = outputTensor.dataAsFloatArray
        result.success(scores.asList())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
