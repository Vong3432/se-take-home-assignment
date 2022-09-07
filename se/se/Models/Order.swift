//
//  Order.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import Foundation

enum OrderStatus: String {
    case pending = "PENDING"
    case processing = "PROCESSING"
    case complete = "COMPLETE"
}

struct Order: Identifiable, Equatable {
    var id = UUID().uuidString
    var status: OrderStatus
    let isVIP: Bool
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
}
