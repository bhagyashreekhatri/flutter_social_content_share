import Flutter
import UIKit
import FBSDKShareKit
import Photos
import MessageUI

public class SwiftFlutterSocialContentSharePlugin: NSObject, FlutterPlugin, SharingDelegate {
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        
    }
    
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
        } else if (call.method == "shareOnWhatsapp"){
            if let arguments = call.arguments as? [String:Any] {
                let number = arguments["number"] as? String ?? ""
                let text = arguments["text"] as? String ?? ""
                shareWhatsapp(withNumber: number, withTxtMsg: text)
            }
        }

        else if (call.method == "shareOnSMS"){
            if let arguments = call.arguments as? [String:Any] {
                let recipients = arguments["recipients"] as? [String] ?? []
                let text = arguments["text"] as? String ?? ""
                sendMessage(withRecipient: recipients,withTxtMsg: text)
            }
        }
            
        else if (call.method == "shareOnEmail"){
            if let arguments = call.arguments as? [String:Any] {
                let recipients = arguments["recipients"] as? [String] ?? []
                let ccrecipients = arguments["ccrecipients"] as? [String] ?? []
                let bccrecipients = arguments["bccrecipients"] as? [String] ?? []
                let subject = arguments["subject"] as? String ?? ""
                let body = arguments["body"] as? String ?? ""
                let isHTML = arguments["isHTML"] as? Bool ?? false
                sendEmail(withRecipient: recipients, withCcRecipient: ccrecipients, withBccRecipient: bccrecipients, withBody: body, withSubject: subject, withisHTML: isHTML)
            }
        }
    }
    
    //MARK: SHARE POST ON FACEBOOK WITHOUT IMAGE
    private func shareFacebookWithoutImage(withQuote quote: String?, withUrl urlString: String?) {
        DispatchQueue.main.async {
            let shareContent = ShareLinkContent()
            if let url = urlString {
                shareContent.contentURL = URL.init(string: url)!
            }
            if let quoteString = quote {
                shareContent.quote = quoteString.htmlToString
            }
            if let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
                let shareDialog = ShareDialog(
                    viewController: flutterAppDelegate.window.rootViewController,
                    content: shareContent,
                    delegate: self
                )
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
            try PHPhotoLibrary.shared().performChangesAndWait{
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                self.shareURL = "instagram://library?LocalIdentifier=" + assetID
                
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
                    self.result?("Instagram app is not installed on your device")
                }
            }
        } catch {
            if let result = result {
                self.result?("Failure")
                result(false)
            }
        }
    }
    
    
    //MARK: SHARE VIA WHATSAPP
    
    func shareWhatsapp(withNumber number: String, withTxtMsg txtMsg: String){
        let urlString = txtMsg.htmlToString
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let appURL  = NSURL(string: "whatsapp://send?phone=\(String(describing: number))&text=\(urlStringEncoded!)")
        if UIApplication.shared.canOpenURL(appURL! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL! as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL! as URL)
            }
            self.result?("Success")
        }
        else {
            self.result?("Whatsapp app is not installed on your device")
        }
    }
    //MARK: SEND MESSAGE
    
    func sendMessage(withRecipient recipent: [String],withTxtMsg txtMsg: String) {
        let string = txtMsg
        if (MFMessageComposeViewController.canSendText()) {
            self.result?("Success")
            let controller = MFMessageComposeViewController()
            controller.body = string.htmlToString
            controller.recipients = recipent
            controller.messageComposeDelegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
        } else {
            self.result?("Message service is not available")
        }
    }
    
    
    //MARK: SEND EMAIL
    
    func sendEmail(withRecipient recipent: [String], withCcRecipient ccrecipent: [String],withBccRecipient bccrecipent: [String],withBody body: String, withSubject subject: String, withisHTML isHTML:Bool ) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: isHTML)
            mail.setToRecipients(recipent)
            mail.setCcRecipients(ccrecipent)
            mail.setBccRecipients(bccrecipent)
            UIApplication.shared.keyWindow?.rootViewController?.present(mail, animated: true, completion: nil)
        } else {
            self.result?("Mail services are not available")
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

//MARK: MFMessageComposeViewControllerDelegate
extension SwiftFlutterSocialContentSharePlugin:MFMessageComposeViewControllerDelegate{
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        let map: [MessageComposeResult: String] = [
            MessageComposeResult.sent: "sent",
            MessageComposeResult.cancelled: "cancelled",
            MessageComposeResult.failed: "failed",
        ]
        if let callback = self.result {
            callback(map[result])
        }
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}


//MARK: MFMailComposeViewControllerDelegate
extension SwiftFlutterSocialContentSharePlugin: MFMailComposeViewControllerDelegate{
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
