//
//  Data.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 08/10/2022.
//

import Foundation
import SwiftUI

struct Data: Identifiable, Codable, Equatable {
    let id: UUID
    var savedText: String

    init(id: UUID = UUID(), savedText: String) {
        self.id = id
        self.savedText = savedText
    }
}

extension Data {
    static let sampleData: Data = Data(savedText: "Hello world!")
}
