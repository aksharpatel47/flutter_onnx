import Flutter
import UIKit

public class SwiftFlutterPytorchOnnxPlugin: NSObject, FlutterPlugin {
    var module: TorchModule?
    var reg: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_pytorch_onnx", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPytorchOnnxPlugin()
        instance.reg = registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.method)
        if (call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if (call.method == "loadModule") {
            
            if let arguments = call.arguments as? Array<String> {
                let modelPath = arguments.first!

                let key = reg?.lookupKey(forAsset: modelPath)
                let path = Bundle.main.path(forResource: key, ofType: nil)
//                result(path)
                module = NLPTorchModule(fileAtPath: path!)
                print("Model Loaded")
                result(true)
            }
        } else if (call.method == "getModuleClasses") {
            if let nlpModule = module as? NLPTorchModule {
                result(nlpModule.topics())
            }
        } else if (call.method == "analyzeText") {
            if let arguments = call.arguments as? Array<String> {
                let text = arguments.first!
                if let nlpModule = module as? NLPTorchModule {
                    let scores = nlpModule.predict(text: text)
                    result(scores)
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
