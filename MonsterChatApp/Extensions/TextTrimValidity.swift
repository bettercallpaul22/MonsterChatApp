//
//  TextTrimValidity.swift
//  MonsterChat
//
//  Created by Obaro Paul on 05/06/2024.
//

import Foundation

extension String{
    var isEmptyOrwithWiteSpace:Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
