//
//  YNPhotoPickerManager.swift
//  Demo
//
//  Created by liyangly on 1/4/21.
//  Copyright © 2021 liyang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

typealias OperationBlock = () -> ()

class YNPhotoPickerManager: NSObject {
    
    //MARK: Permission
    
    public class func cameraPermissions(authorizedBlock: OperationBlock?, vc: UIViewController) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                self.cameraPermissions(authorizedBlock: authorizedBlock, vc: vc)
            })
        } else if authStatus == .authorized {
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        } else {
            self.showAuthorizationAlert(isCamera: true, isPhotoRead: true, vc: vc, cancel: nil)
        }
    }
    
    public class func cameraPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                self.cameraPermissions(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
            })
        } else if authStatus == .authorized {
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        } else {
            if deniedBlock != nil {
                deniedBlock!()
            }
        }
    }
    
    public class func photoAlbumPermissions(authorizedBlock: OperationBlock?, vc: UIViewController) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                self.photoAlbumPermissions(authorizedBlock: authorizedBlock, vc: vc)
            }
        } else if authStatus == .authorized  {
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        } else {
            self.showAuthorizationAlert(isCamera: false, isPhotoRead: true, vc: vc, cancel: nil)
        }
    }
    
    public class func photoAlbumPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                self.photoAlbumPermissions(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
            }
        } else if authStatus == .authorized  {
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        } else {
            if deniedBlock != nil {
                deniedBlock!()
            }
        }
    }
    
    //MARK: showAuthorizationAlert
    
    public class func showAuthorizationAlert(isCamera: Bool, isPhotoRead: Bool, vc: UIViewController, cancel: OperationBlock?) {
        
        if let infoDict = Bundle.main.infoDictionary {
            
            let title = isCamera ? "We Would Like to Access Your Camera" : "We Would Like to Access Your Photo Gallery"
            let message = isCamera ? infoDict["NSCameraUsageDescription"] : (isPhotoRead ? infoDict["NSPhotoLibraryUsageDescription"] : infoDict["NSPhotoLibraryAddUsageDescription"])
            
            let alert = UIAlertController(title: title, message: message as? String, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
                if cancel != nil {
                    cancel!()
                }
            }))
            alert.addAction(UIAlertAction(title: "Enable", style: UIAlertAction.Style.default, handler: { (_) in
                
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }))
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showAuthorizationAlert(title: String, message: String, vc: UIViewController, cancel: OperationBlock?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
            if cancel != nil {
                cancel!()
            }
        }))
        alert.addAction(UIAlertAction(title: "Enable", style: UIAlertAction.Style.default, handler: { (_) in
            
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Picker
    
    public lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    public var finishPickingMediaWithInfo: ([UIImagePickerController.InfoKey: Any]) -> () = {info in}
    
    
    public func openCaremaPresentFrom(_ vc: UIViewController) {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        vc.present(imagePicker, animated: true, completion: nil)
    }
    
    public func openAlbumPresentFrom(_ vc: UIViewController) {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        vc.present(imagePicker, animated: true, completion: nil)
    }
}

extension YNPhotoPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {[weak self] in
            self?.finishPickingMediaWithInfo(info)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
