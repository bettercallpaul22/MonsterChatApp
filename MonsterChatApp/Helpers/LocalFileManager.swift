//
//  LocalFileManager.swift
//  SwiftCryptoApp
//
//  Created by Obaro Paul on 28/05/2024.
//

import Foundation
import SwiftUI

// Singleton class to manage local file operations
class LocalFileManager {
    
    static let instance = LocalFileManager()
   
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
    
    
    func getImageFromLocalStrorage(imagePathUrl:String , completion:@escaping(_ image:UIImage?)-> Void){
        if imagePathUrl.isEmpty{
            print("no url image path or invalid url")
            return
        }
        if let image = UIImage(contentsOfFile: imagePathUrl){
            DispatchQueue.main.async {
                completion(image)
            }
        }else{
            completion(nil)
        }
    }
    
    func saveFileLocally(image:UIImage, fileName:String){
        print("saveFileLocally image typr", fileName + ".jpg")
        let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            
        if let documentDirectory: URL = urls.first {
            let fileURL = documentDirectory.appendingPathComponent(fileName + ".jpg")
            if let imageData =   image.jpegData(compressionQuality: 0.6){
                do {
                    print("saveFileLocally write type", imageData)
                try imageData.write(to: fileURL)
                //                    print("returned fileURL after write success", fileURL)
                //                    return fileURL
            } catch {
                print("Error writing data to file: \(error)")
            }
        }
            }
//            return nil
    }
    
    
    
//    func saveFileLocally(fileData:NSData, fileName:String){
//        let fileManager = FileManager.default
//            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//            
//            if let documentDirectory: URL = urls.first {
//                let fileURL = documentDirectory.appendingPathComponent(fileName)
//                do {
//                    try fileData.write(to: fileURL)
////                    print("returned fileURL after write success", fileURL)
////                    return fileURL
//                } catch {
//                    print("Error writing data to file: \(error)")
//                }
//            }
////            return nil
//    }
    
    
}


//file:///Users/bettercallpaul/Library/Developer/CoreSimulator/Devices/7174CDDA-953B-4E87-8DD0-F18DC1200C2E/data/Containers/Data/Application/1682ADB2-DE61-4F4E-B22A-3CEEFE8F9155/Documents/SjVfsykrQzbtNUrGaX4MTAZEJdw2
