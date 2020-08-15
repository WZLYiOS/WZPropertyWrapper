//
//  DynamicUIColor.swift
//  PropertyWrapperDemo
//
//  Created by xiaobin liu on 2019/11/21.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/// [Courtesy of @bardonadam](https://twitter.com/bardonadam)
@propertyWrapper
public struct DynamicUIColor {

    /// Backwards compatible wrapper arround UIUserInterfaceStyle
    public enum Style {
        case light, dark
    }
    
    let light: UIColor
    let dark: UIColor
    let styleProvider: () -> Style?

    public init(
        light: UIColor,
        dark: UIColor,
        style: @autoclosure @escaping () -> Style? = nil
    ) {
        self.light = light
        self.dark = dark
        self.styleProvider = style
    }

    public var wrappedValue: UIColor {
        switch styleProvider() {
        case .dark: return dark
        case .light: return light
        case .none:
            // UIColor(dynamicProvider:) only available on iOS >=13+ & tvOS >=13
            #if os(iOS) || os(tvOS)
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark: return self.dark
                    case .light, .unspecified: return self.light
                    @unknown default: return self.light
                    }
                }
            } else {
                return light
            }
            #else
            return light
            #endif
        }
    }
}
#endif
