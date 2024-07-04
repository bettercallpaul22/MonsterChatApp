//
//  SearchField.swift
//  MonsterChat
//
//  Created by Obaro Paul on 12/06/2024.
//

import SwiftUI

struct SearchField: View {
    @StateObject var userViewModel:UserViewModel = UserViewModel()
    @Binding var searchText:String
    @FocusState var focus:Bool

    
    var body: some View {
        HStack{
            TextField("Search Users", text: $searchText)
                .focused($focus)
                .padding(12)
//                .focused($isFocused)
                .overlay(alignment: .trailing, content: {
                    Button(action: {
                       
                    }, label: {
                        Image(systemName: "xmark.circle.fill") // Example button image
                            .padding(10)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    })
                    
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
        }.padding()
        
            .cornerRadius(20)
            .shadow(color: .gray, radius: 5, x: 0, y: 2) // Adding shadow for better appearance
        
    }
}

struct SearchField_Previews: PreviewProvider {
    @FocusState static private var isFocused:Bool

    static var previews: some View {
        SearchField(searchText: .constant(""))
    }
}
