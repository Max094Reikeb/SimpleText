//
//  Utilities.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 27/09/2022.
//

import Foundation
import SwiftUI

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
