//
//  PhotoPicker.swift
//  MonsterChat
//
//  Created by Obaro Paul on 28/06/2024.
//

import Foundation
import SwiftUI

struct PhotoPicker:UIViewControllerRepresentable{
    @Binding var Image:UIImage?
    var completion: (() -> Void)?
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        
        return picker
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    
    
    func makeCoordinator() ->Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    
    // This trggered when an image is picked
    
    final class Coordinator:NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let photoPicker:PhotoPicker
        init(photoPicker:PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage{
                photoPicker.Image = image
            }else{}
            picker.dismiss(animated: true) {
                self.photoPicker.completion?()
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
