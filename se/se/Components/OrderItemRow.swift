//
//  OrderItemRow.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import SwiftUI

struct OrderItemRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ORDER: \(order.id)")
                .font(.headline)
            
            if order.isVIP {
                Text("VIP")
                    .font(.subheadline)
                    .padding(.horizontal)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    
            }
        }
    }
}

struct OrderItemRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemRow(order: Order(status: .pending, isVIP: false))
    }
}
