import Flutter
import UIKit
import FBSDKShareKit
import Photos

public class SwiftFlutterSocialContentSharePlugin: NSObject, FlutterPlugin {
    var result: FlutterResult?
    var shareURL:String?
    
    //MARK: PLUGIN REGISTRATION
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_social_content_share", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterSocialContentSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    //MARK: FLUTTER HANDLER CALL
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "share"{
            if let arguments = call.arguments as? [String:Any] {
                let type = arguments["type"] as? String ?? "ShareType.more"
                let shareQuote = arguments["quote"] as? String ?? ""
                let shareUrl = arguments["url"] as? String ?? ""
                let shareImageUrl = arguments["imageUrl"] as? String ?? ""
                _ = arguments["imageName"] as? String ?? ""
                
                switch type {
                case "ShareType.facebookWithoutImage":
                    shareFacebookWithoutImage(withQuote: shareQuote, withUrl: shareUrl)
                    break
                    
                case "ShareType.instagramWithImageUrl":
                    self.result?(shareImageUrl)
                    let url = URL(string: shareImageUrl)
                    if let urlData = url {
                        let data = try? Data(contentsOf: urlData)
                        if let datas = data {
                            shareInstagramWithImageUrl(image: UIImage(data: datas) ?? UIImage()) { (flag) in
                            }
                        }else{
                            self.result?("Something went wrong")
                        }
                    }
                    else{
                        self.result?("Could not load the image")
                    }
                    break
                case "ShareType.more":
                    self.result?("Method not implemented")
                    break
                default:
                    break
                }
            }
        }
    }
    
    //MARK: SHARE POST ON FACEBOOK WITHOUT IMAGE
    private func shareFacebookWithoutImage(withQuote quote: String?, withUrl urlString: String?) {
        DispatchQueue.main.async {
            let shareContent = ShareLinkContent()
            let shareDialog = ShareDialog()
            if let url = urlString {
                shareContent.contentURL = URL.init(string: url)!
            }
            if let quoteString = quote {
                shareContent.quote = quoteString.htmlToString
            }
            shareDialog.shareContent = shareContent
            if let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
                shareDialog.fromViewController = flutterAppDelegate.window.rootViewController
                shareDialog.mode = .automatic
                shareDialog.show()
                self.result?("Success")
            } else{
                self.result?("Failure")
            }
        }
    }
    
    //MARK: SHARE POST ON INSTAGRAM WITH IMAGE NETWORKING URL
    private func shareInstagramWithImageUrl(image: UIImage, result:((Bool)->Void)? = nil) {
        guard let instagramURL = NSURL(string: "instagram://app") else {
            if let result = result {
                self.result?("Instagram app is not installed on your device")
                result(false)
            }
            return
        }
        
        //Save image on device
        do {
            try PHPhotoLibrary.shared().performChangesAndWait({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                self.shareURL = "instagram://library?LocalIdentifier=" + assetID
            })
        } catch {
            if let result = result {
                self.result?("Failure")
                result(false)
            }
        }
        
        //Share image
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            if let sharingUrl = self.shareURL {
                if let urlForRedirect = NSURL(string: sharingUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlForRedirect as URL, options: [:], completionHandler: nil)
                    }
                    else{
                        UIApplication.shared.openURL(urlForRedirect as URL)
                    }
                }
                self.result?("Success")
            }
        } else{
            self.result?("Something went wrong")
        }
    }
}


//MARK: EXTENSIONS FOR STRING
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
