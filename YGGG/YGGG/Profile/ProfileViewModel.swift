//
//  ProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/6/24.
//

import Foundation


struct User {
    let userImage: String
    let userName: String
    let userHashTag: String
    let refrigeratorCount: Int
    let tombCount: Int
    let isFavorite: Bool
    
    let userCosmetics: [Cosmetics]
}

struct TopCategory {
    let imageName: String
    let title: String
}


struct Cosmetics {
    let imageName: String
    let title: String
    let purchaseDate: Date
    let expirationDate: Date
    let kind: Int // 0: 냉동, 1: 냉장, 2: 실온
    
    var isExpired: Bool {
         return expirationDate < Date()
     }
    
    var purchaseString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: purchaseDate)
    }
    
    var expirationString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: expirationDate)
    }
    
}

class ProfileViewModel {
    ///MockUp Data
    private var topCategorys: [TopCategory] = [
        TopCategory(imageName: "allmenu", title: "전체"),
        TopCategory(imageName: "snowflake", title: "냉동"),
        TopCategory(imageName: "fridge", title: "냉장"),
        TopCategory(imageName: "body", title: "실온")
    ]
    
    ///return Category Count [ 전체, 냉동, 냉장, 실온 ]
    func topCateogoryCount() -> Int {
        return topCategorys.count
    }
    
    func getCategoryItem(index: Int) -> TopCategory {
        return topCategorys[index]
    }
    
    
    
    ///Cosmetics MockUp Data
    private lazy var cosmeticsList: [Cosmetics] = [
        Cosmetics(imageName: "waterbottle", title: "로션",
                  purchaseDate: minusDate(minus: 10), expirationDate: addDate(add:5), kind: 0),
        Cosmetics(imageName: "waterbottle", title: "핸드크림",
                  purchaseDate: minusDate(minus: 10), expirationDate: minusDate(minus: 1), kind: 1),
        Cosmetics(imageName: "waterbottle", title: "립밤",
                  purchaseDate: minusDate(minus: 3), expirationDate: addDate(add:5), kind: 2),
        Cosmetics(imageName: "waterbottle", title: "선크림",
                  purchaseDate: minusDate(minus: 10), expirationDate: minusDate(minus: 2), kind: 0)
    ]
    
    init() {
        self.selectedCosmeticList = cosmeticsList
    }
    
    
    private lazy var selectedCosmeticList: [Cosmetics] = []
    
    private func addDate(add: Int) -> Date {
        let addDay = Calendar.current.date(byAdding: .day, value: add, to: Date())
        return addDay!
    }
    
    private func minusDate(minus: Int) -> Date {
        let minusDate = Calendar.current.date(byAdding: .day, value: -minus, to: Date())
        return minusDate!
    }
    
    
    func cosmeticsCount() -> Int {
        return self.selectedCosmeticList.count
    }
    
    func getCosmetic(index: Int) -> Cosmetics {
        return self.selectedCosmeticList[index]
    }
    
    func getSectionCosmetic(caseType: Int, completion: @escaping() -> Void ) {
        switch caseType {
        case 1:
            selectedCosmeticList = cosmeticsList.filter { $0.kind == 0 }
        case 2:
            selectedCosmeticList = cosmeticsList.filter { $0.kind == 1 }
        case 3:
            selectedCosmeticList = cosmeticsList.filter { $0.kind == 2 }
        default:
            selectedCosmeticList = cosmeticsList
        }
        completion()
    }
    
    
}
