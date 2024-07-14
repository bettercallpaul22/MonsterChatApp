//
//  Constants.swift
//  MonsterChat
//
//  Created by Obaro Paul on 04/06/2024.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage
import RealmSwift


public let mCurrentUser = "currentUser"
public let mFolderName = "monsterChat"
public let mChatRoomId = "chatRoomId"
public let mSenderId = "senderId"
public let mMessageStatusSent = "sent"
public let mMessageStatusRead = "read"
public let mDATE = "date"
public let mlastMessageObject = "lastMessageObject"

public enum MessageType:String{
    case text
    case audio
    case photo
    case video
    case location

}


public enum FireBaseRefEnum:String{
    case User
    case Recent
    case Messages
    case Typing
    case MessageViewListener
}

public enum UserViewState:String{
   case online
   case inMessageView
    case offline
}

public enum SenderType{
    case sender
    case receiver
}

public enum FireBaseImageUrlPath:String{
    case avatar = "Avatars/"
    case photoMessage = "Media/Photos/"
}



public let AvatarPhotoDirectory = Storage.storage().reference(forURL: mStorage_BaseUrl).child(mFirebaseImageDirectory)
public let MessagePhotoDirectory = Storage.storage().reference(forURL: mStorage_BaseUrl)


public let mStorage_BaseUrl = "gs://monsterchatapp.appspot.com"
public let mFirebaseImageDirectory = "Avatars/" + "_\(String(describing: User.currentUserId))" + ".jpg"
public let  AvatarDirectory = Storage.storage().reference(forURL: mStorage_BaseUrl).child(mFirebaseImageDirectory)






