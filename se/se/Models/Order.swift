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

class Order: Identifiable, Equatable, ObservableObject {
    var id: String
    @Published var status: OrderStatus
    let isVIP: Bool
    
    init(id: String? = nil, status: OrderStatus, isVIP: Bool) {
        self.id = id ?? UUID().uuidString
        self.status = status
        self.isVIP = isVIP
    }
    
    static func ==(lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id 
    }
    
}
