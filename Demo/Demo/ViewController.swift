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
        
        YNPhotoPickerManager.share.finishPickingMediaWithInfo = {[weak self] info in
            if let image = info[UIImagePickerController.InfoKey.originalImage] {
                print(image)
            }
        }
    }
    
    func openCamera() {
        
        YNPhotoPickerManager.share.cameraPermissions(authorizedBlock: {
            YNPhotoPickerManager.share.openCaremaPresentFrom(self)
        }, vc: self)
    }
    
    func openAlbum() {
        
        YNPhotoPickerManager.share.photoAlbumPermissions(authorizedBlock: {
            YNPhotoPickerManager.share.openAlbumPresentFrom(self)
        }, vc: self)
    }

}

