//
//  ModalViewModel.swift
//  YGGG
//
//  Created by Song Kim on 6/10/24.
//

import Foundation

class ModalViewModel {
    let options = cosmeticOptions
    var selectedIndex: Int? = nil
    
    var selectedOption: String {
        if let selectedIndex {
            return options[selectedIndex]
        } else {
            return "선택"
        }
    }
}
