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

public typealias YNOperationBlock = () -> ()

public class YNPhotoPickerManager: NSObject {
    
    public static let share = YNPhotoPickerManager()
    
    //MARK: openCarema / openAlbum
    public func openCaremaPresentFrom(_ vc: UIViewController) {
        
        cameraPermissions(authorizedBlock: {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            vc.present(self.imagePicker, animated: true, completion: nil)
        }, vc: vc)
    }
    
    public func openAlbumPresentFrom(_ vc: UIViewController) {
        
        photoAlbumPermissions(authorizedBlock: {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            vc.present(self.imagePicker, animated: true, completion: nil)
        }, vc: vc)
    }
    
    //MARK: Permission
    
    public func cameraPermissions(authorizedBlock: YNOperationBlock?, vc: UIViewController) {
        
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
    
    public func cameraPermissions(authorizedBlock: YNOperationBlock?, deniedBlock: YNOperationBlock?) {
        
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
    
    public func photoAlbumPermissions(authorizedBlock: YNOperationBlock?, vc: UIViewController) {
        
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
    
    public func photoAlbumPermissions(authorizedBlock: YNOperationBlock?, deniedBlock: YNOperationBlock?) {
        
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
    
    public func showAuthorizationAlert(isCamera: Bool, isPhotoRead: Bool, vc: UIViewController, cancel: YNOperationBlock?) {
        
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
    
    public func showAuthorizationAlert(title: String, message: String, vc: UIViewController, cancel: YNOperationBlock?) {
        
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
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    public var finishPickingMediaWithInfo: ([UIImagePickerController.InfoKey: Any]) -> () = {info in}
    
}

extension YNPhotoPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {[weak self] in
            self?.finishPickingMediaWithInfo(info)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
