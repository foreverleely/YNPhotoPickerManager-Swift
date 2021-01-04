//
//  ViewController.swift
//  Demo
//
//  Created by liyangly on 1/4/21.
//  Copyright © 2021 liyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    func openCamera() {
        
        YNPhotoPickerManager.cameraPermissions(authorizedBlock: {
            self.imgaePicker.openCaremaPresentFrom(self)
        }, vc: self)
    }
    
    func openAlbum() {
        
        YNPhotoPickerManager.photoAlbumPermissions(authorizedBlock: {
            self.imgaePicker.openAlbumPresentFrom(self)
        }, vc: self)
    }

    lazy var imgaePicker: YNPhotoPickerManager = {
        let imagePicker = YNPhotoPickerManager()
        imagePicker.finishPickingMediaWithInfo = {[weak self] info in
            if let image = info[UIImagePickerController.InfoKey.originalImage] {
                print(image)
            }
        }
        return imagePicker
    }()
}

