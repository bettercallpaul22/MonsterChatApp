//
//  GlobalFunction.swift
//  MonsterChat
//
//  Created by Obaro Paul on 08/06/2024.
//

import Foundation
import SwiftUI


func fileNameTrimmer(fileUrl:String) -> String{
    let splitUrl = fileUrl.components(separatedBy: "_").last!
    let fileName = splitUrl.components(separatedBy: "?").first!
    return fileName
}

func convertUIImageToNSData(image: UIImage) -> NSData? {
    return image.jpegData(compressionQuality: 0.2) as NSData?
}
