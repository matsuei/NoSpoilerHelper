//
//  Item+Extension.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/01/23.
//

import Foundation

extension Item {
     override public func awakeFromInsert() {
         super.awakeFromInsert()
         id = UUID()
         createdAt = Date()
     }
 }
