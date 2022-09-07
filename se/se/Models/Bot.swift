//
//  Bot.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import Foundation

struct Bot: Identifiable, Equatable {
    var id = UUID().uuidString
    var order: Order?
    
    static func ==(lhs: Bot, rhs: Bot) -> Bool {
        lhs.id == rhs.id
    }
}
