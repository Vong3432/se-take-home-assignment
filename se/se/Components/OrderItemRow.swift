//
//  OrderItemRow.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import SwiftUI

struct OrderItemRow: View {
    let id: String
    let isVIP: Bool
    let status: OrderStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ORDER: \(id)")
                .font(.headline)
            
            HStack {
                if isVIP {
                    Text("VIP")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .background(Color.orange)
                        .foregroundColor(.white)
                    
                }
                
                if status == .processing {
                    ProgressView()
                }
            }
        }
    }
}

struct OrderItemRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemRow(id: "123", isVIP: true, status: .complete)
    }
}
