//
//  LocalFileManager.swift
//  SwiftCryptoApp
//
//  Created by Obaro Paul on 28/05/2024.
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage

// Singleton class to manage local file operations
class LocalFileManager {
    
    static let instance = LocalFileManager()
    private var cancellables = Set<AnyCancellable>()

    func getDocumentDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // This will give us complete path where our file is
    func fileInDocumentDirectory(filename:String) -> String {
        return getDocumentDirectory()!.appendingPathComponent(filename).path // MonsterChat + img.jpg
    }
    
    
    func fileExistingAtPath(path:String) -> Bool{
        let filePath = fileInDocumentDirectory(filename: path) // MonsterChat + img.jpg
        
        // check is this path exist : // MonsterChat + img.jpg
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    
    
    func getImageFromLocalStorage(_ imageName: String) -> AnyPublisher<UIImage, Error> {
        Future<UIImage, Error> { promise in
            
            let filename = self.getDocumentDirectory()?.appendingPathComponent(imageName + ".jpg")
            
            do{
                let data = try Data(contentsOf: filename!)
                promise(.success(UIImage(data: data)!))
            }catch{
                promise(.failure(NSError(domain: "Image not found", code: 1, userInfo: nil)))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func saveImageLocally(image:UIImage, fileName:String){
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectory: URL = urls.first {
            let fileURL = documentDirectory.appendingPathComponent(fileName + ".jpg")
            if let imageData =   image.jpegData(compressionQuality: 0.6){
                do {
                    try imageData.write(to: fileURL)
                    print("returned fileURL after write success", fileURL)
                    
                } catch {
                    print("Error writing data to file: \(error)")
                }
            }
        }
    }
    
    
    func readAnWriteImage( fileName:String, firebaseImageUrlPath:FireBaseImageUrlPath)->AnyPublisher<UIImage?, Error>{
        Future<UIImage?, Error>{ [self] promise in
        if fileExistingAtPath(path: fileName + ".jpg"){
            getImageFromLocalStorage(fileName)
                .sink { completion in
                    switch completion{
                    case .failure(_):
                        print("error getting image from localFilePath")
                    case .finished:
                        break
                    }
                } receiveValue: { image in
                    promise(.success(image))
                }.store(in: &cancellables)
            
        }else{
            FirebaseHelper.instance.downloadImage(firebaseImageUrl:firebaseImageUrlPath.rawValue, fileName: fileName)
                .sink { completion in
                    switch completion{
                    case .failure(let error):
                        print("error getting image from firebase")
                        promise(.failure(error))

                    case .finished:
                        break
                    }
                } receiveValue: { image in
                    promise(.success(image))
                }.store(in: &cancellables)
        }
        
        }.eraseToAnyPublisher()
    
    }
    

    
    
    
    
    
    
    
    
    
    
}


//file:///Users/bettercallpaul/Library/Developer/CoreSimulator/Devices/7174CDDA-953B-4E87-8DD0-F18DC1200C2E/data/Containers/Data/Application/1682ADB2-DE61-4F4E-B22A-3CEEFE8F9155/Documents/SjVfsykrQzbtNUrGaX4MTAZEJdw2
