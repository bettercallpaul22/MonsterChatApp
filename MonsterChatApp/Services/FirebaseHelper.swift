//
//  FirebaseHelper.swift
//  MonsterChatApp
//
//  Created by Obaro Paul on 03/07/2024.
//

import Foundation
import FirebaseStorage
import Combine
import SwiftUI

class FirebaseHelper{
    static let instance = FirebaseHelper()
    init(){}
    
    func uploadImage(image: UIImage, directory:FireBaseImageUrlPath, fileName:String) -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            let fileNameUrl = directory.rawValue + "\(fileName)" + ".jpg"
            let filePathUrl =  Storage.storage().reference(forURL: mStorage_BaseUrl).child(fileNameUrl)

                guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                    promise(.failure(NSError(domain: "ImageUploader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                    return
                }
                
            filePathUrl.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                filePathUrl.downloadURL { url, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if let url = url {
                            promise(.success(url.absoluteString))

                        }
                    }
                }
            
        }.eraseToAnyPublisher()
    }
    
    
    
    func downloadImage(firebaseImageUrl: String, fileName:String) -> Future<UIImage?, Error> {
        let fileNameUrl = firebaseImageUrl + "\(fileName)" + ".jpg"

     let image = Storage.storage().reference(forURL: mStorage_BaseUrl).child(fileNameUrl)
        return Future { promise in
            image.getData(maxSize: 10 * 1024 * 1024) { result in
                switch result {
                case .success(let data):
                    if UIImage(data: data) != nil {
                        
                        if let imageData = UIImage(data: data) {
                            promise(.success(imageData))
                            LocalFileManager.instance.saveImageLocally(image: imageData, fileName: fileName)
                        }
                    } else {
                        promise(.success(nil))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
