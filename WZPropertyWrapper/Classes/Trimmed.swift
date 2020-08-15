//
//  Trimmed.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Trimmed {
    private var value: String!
    private let characterSet: CharacterSet
    
    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: characterSet) }
    }
    
    public init(wrappedValue: String) {
        self.characterSet = .whitespacesAndNewlines
        self.wrappedValue = wrappedValue
    }
    
    public init(wrappedValue: String, characterSet: CharacterSet) {
        self.characterSet = characterSet
        self.wrappedValue = wrappedValue
    }
}
