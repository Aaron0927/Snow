//
//  Observable.swift
//  Snow
//
//  Created by kim on 2024/7/25.
//

import Foundation

class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    var value: T {
        didSet {
           observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(_ observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
