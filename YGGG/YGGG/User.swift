//
//  UserInfoEntry.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit
import FirebaseFirestore

class User: Codable {
    let email: String
    let uid: String
    var userCosmetics: [UserCosmetics]
    var userHashTag: String?
    var userImage: String?
    let userName: String
    var bookmarkList: [String]
    
    init(email: String, uid: String, userCosmetics: [UserCosmetics], userHashTag: String? = nil, userImage: String? = nil, userName: String, bookmarkList: [String]) {
        self.email = email
        self.uid = uid
        self.userCosmetics = userCosmetics
        self.userHashTag = userHashTag
        self.userImage = userImage
        self.userName = userName
        self.bookmarkList = bookmarkList
    }
}

class UserCosmetics: Codable {
    let expirationDate: Timestamp
    let purchaseDate: Timestamp
    let title: String
    let imageName: String
    let kind: Int
    
    init(expirationDate: Timestamp, purchaseDate: Timestamp, title: String, imageName: String, kind: Int) {
        self.expirationDate = expirationDate
        self.purchaseDate = purchaseDate
        self.title = title
        self.imageName = imageName
        self.kind = kind
    }
}
