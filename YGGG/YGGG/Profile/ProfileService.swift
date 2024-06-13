//
//  ProfileService.swift
//  YGGG
//
//  Created by Chung Wussup on 6/8/24.
//

import Foundation
import Firebase


let DB_RED = Firestore.firestore()
let RED_USERS = DB_RED.collection("users")



struct ProfileService {
    
    static let shared = ProfileService()
    
    func getData(uid: String, completion: @escaping(User) -> Void) {
        
        RED_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if var data = document.data() {
                      
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy.MM.dd"
                        
                        if let userCosmetics = data["userCosmetics"] as? [[String: Any]] {
                            var updatedUserCosmetics = [[String: Any]]()
                            
                            for var cosmetic in userCosmetics {
                                if let expirationDate = cosmetic["expirationDate"] as? Timestamp {
                                    cosmetic["expirationDate"] = dateFormatter.string(from: expirationDate.dateValue())
                                }
                                if let purchaseDate = cosmetic["purchaseDate"] as? Timestamp {
                                    cosmetic["purchaseDate"] = dateFormatter.string(from: purchaseDate.dateValue())
                                }
                                updatedUserCosmetics.append(cosmetic)
                            }
                            data["userCosmetics"] = updatedUserCosmetics
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: jsonData)
                        
                        completion(user)
                    }
                } catch let error {
                    print("Error converting document data to JSON: \(error)")
                }
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
}