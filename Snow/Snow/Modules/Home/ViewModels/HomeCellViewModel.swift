//
//  HomeCellViewModel.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import Foundation

class HomeCellViewModel {
    var name: Observable<String?> = Observable("--")
    var image: Observable<String> = Observable("")
    var publishTime: Observable<String> = Observable("--")
    var content: Observable<NSAttributedString?> = Observable(NSAttributedString(string: "--"))
    var focus: Observable<Bool> = Observable(false)
    
    init() {
    }
}
