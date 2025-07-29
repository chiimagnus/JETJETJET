//
//  Item.swift
//  JETJETJET
//
//  Created by chii_magnus on 2025/7/29.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
