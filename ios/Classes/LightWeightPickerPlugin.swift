import Flutter
import UIKit
import UniformTypeIdentifiers

public class LightWeightPickerPlugin: NSObject, FlutterPlugin, UIDocumentPickerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "light_weight_picker", binaryMessenger: registrar.messenger())
    let instance = LightWeightPickerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "browseAndGetFile":
        guard let args = call.arguments as? [String : Any] else {return}
        if let fileTypes:NSArray = args["fileTypes"] as? NSArray{
            if #available(iOS 14.0, *) {
                getSupportedTypesForUtTypes(list: fileTypes)
            }
            selectFiles(result: result)
        }
      
        
        
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    func selectFiles(result: @escaping FlutterResult) {
      let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let rootViewController = keyWindow?.rootViewController
        PickerClass.pickerResult = result
        let documentPickerController = getDocumentController()
         documentPickerController.delegate = self
        DispatchQueue.main.async {
            rootViewController?.present(documentPickerController, animated: true, completion: nil)
        }
       
        
     }



     public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var documentData : Data?
        do {
            if let url = urls.first{
                url.startAccessingSecurityScopedResource()
                documentData = try Data(contentsOf: url)
                let encodedDocumnet = documentData?.base64EncodedString()
                var fileInfo:[String:String] = [ "fileExtension":url.pathExtension, "fileName":url.lastPathComponent, "fileBytes":encodedDocumnet ?? ""]
                PickerClass.pickerResult?(fileInfo)
                url.stopAccessingSecurityScopedResource()
            }
        } catch {
           PickerClass.pickerResult?("Data Not Selected")
         print("\(error)")
        }
        
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        PickerClass.pickerResult?("Data Not Selected")
    }


private func getDocumentController () -> UIDocumentPickerViewController{
        var documentPickerController : UIDocumentPickerViewController
        if #available(iOS 14, *) {
        // iOS 14 & later
        documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: utTypeSupportedTypes as! [UTType])
                 } else {
        // iOS 13 or older code
        let supportedTypes: [String] = ["*/*"]
        documentPickerController = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
                 }
        return documentPickerController

     }
    
  
      var utTypeSupportedTypes : [Any] = []

      @available(iOS 14.0, *)
    func getSupportedTypesForUtTypes(list:NSArray) {
      


        list.forEach { e in
            if e as? String == "All"{
                utTypeSupportedTypes = allUTITypes()
            }
            
            if e as? String == "Images"{
                utTypeSupportedTypes.append(UTType.image)
            }else if e as? String == "Audios"{
                utTypeSupportedTypes.append(UTType.audio)
            }else if e as? String == "Videos"{
                utTypeSupportedTypes.append(UTType.video)
            }else if e as? String == "Png"{
                utTypeSupportedTypes.append(UTType.png)
            }else if e as? String == "Jpg"{
                utTypeSupportedTypes.append(UTType.jpeg)
            }else if e as? String == "Pdf"{
                utTypeSupportedTypes.append(UTType.pdf)
            }
            
        }

    
    }
    @available(iOS 14.0, *)
    func allUTITypes() -> [UTType] {
            let types : [UTType] =
                [.item,
                 .content,
                 .compositeContent,
                 .diskImage,
                 .data,
                 .directory,
                 .resolvable,
                 .symbolicLink,
                 .executable,
                 .mountPoint,
                 .aliasFile,
                 .urlBookmarkData,
                 .url,
                 .fileURL,
                 .text,
                 .plainText,
                 .utf8PlainText,
                 .utf16ExternalPlainText,
                 .utf16PlainText,
                 .delimitedText,
                 .commaSeparatedText,
                 .tabSeparatedText,
                 .utf8TabSeparatedText,
                 .rtf,
                 .html,
                 .xml,
                 .yaml,
                 .sourceCode,
                 .assemblyLanguageSource,
                 .cSource,
                 .objectiveCSource,
                 .swiftSource,
                 .cPlusPlusSource,
                 .objectiveCPlusPlusSource,
                 .cHeader,
                 .cPlusPlusHeader]

            let types_1: [UTType] =
                [.script,
                 .appleScript,
                 .osaScript,
                 .osaScriptBundle,
                 .javaScript,
                 .shellScript,
                 .perlScript,
                 .pythonScript,
                 .rubyScript,
                 .phpScript,
                 .json,
                 .propertyList,
                 .xmlPropertyList,
                 .binaryPropertyList,
                 .pdf,
                 .rtfd,
                 .flatRTFD,
                 .webArchive,
                 .image,
                 .jpeg,
                 .tiff,
                 .gif,
                 .png,
                 .icns,
                 .bmp,
                 .ico,
                 .rawImage,
                 .svg,
                 .livePhoto,
                 .heif,
                 .heic,
                 .webP,
                 .threeDContent,
                 .usd,
                 .usdz,
                 .realityFile,
                 .sceneKitScene,
                 .arReferenceObject,
                 .audiovisualContent]

            let types_2: [UTType] =
                [.movie,
                 .video,
                 .audio,
                 .quickTimeMovie,
                 UTType("com.apple.quicktime-image"),
                 .mpeg,
                 .mpeg2Video,
                 .mpeg2TransportStream,
                 .mp3,
                 .mpeg4Movie,
                 .mpeg4Audio,
                 .appleProtectedMPEG4Audio,
                 .appleProtectedMPEG4Video,
                 .avi,
                 .aiff,
                 .wav,
                 .midi,
                 .playlist,
                 .m3uPlaylist,
                 .folder,
                 .volume,
                 .package,
                 .bundle,
                 .pluginBundle,
                 .spotlightImporter,
                 .quickLookGenerator,
                 .xpcService,
                 .framework,
                 .application,
                 .applicationBundle,
                 .applicationExtension,
                 .unixExecutable,
                 .exe,
                 .systemPreferencesPane,
                 .archive,
                 .gzip,
                 .bz2,
                 .zip,
                 .appleArchive,
                 .spreadsheet,
                 .presentation,
                 .database,
                 .message,
                 .contact,
                 .vCard,
                 .toDoItem,
                 .calendarEvent,
                 .emailMessage,
                 .internetLocation,
                 .internetShortcut,
                 .font,
                 .bookmark,
                 .pkcs12,
                 .x509Certificate,
                 .epub,
                 .log]
                    .compactMap({ $0 })

            return types + types_1 + types_2
        }
}


class PickerClass{
   static var pickerResult: FlutterResult?
   
}
