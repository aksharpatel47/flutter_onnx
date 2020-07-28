import Flutter
import UIKit

public class SwiftFlutterPytorchOnnxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pytorch_onnx", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPytorchOnnxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
