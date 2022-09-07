//
//  ContentView.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = Orders()
    
    @State private var id = 0
    @State private var secs = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            List {
                Section("Actions") {
                    Button("New Normal Order") {
                        vm.createOrder(Order(id: "\(id)", status: .pending, isVIP: false))
                        id = id + 1
                    }
                    Button("New VIP Order") {
                        vm.createOrder(Order(id: "\(id)", status: .pending, isVIP: true))
                        id = id + 1
                    }
                }
                
                Section("Bots") {
                    Text("Number: \(vm.bots.count)")
                    Button("+ Bot") {
                        vm.addBot()
                    }
                    Button("- Bot") {
                        vm.removeBot()
                    }
                }
                
                Section("PENDING") {
                    ForEach(pendingOrders) { order in
                        OrderItemRow(order: order)
                    }
                }
                
                Section("COMPLETE") {
                    ForEach(completeOrders) { order in
                        OrderItemRow(order: order)
                    }
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                Text("\(secs)")
                    .onReceive(timer) { _ in
                        secs = secs + 1
                        vm.processOrder()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private var pendingOrders: [Order] {
        vm.orders.filter { $0.status != .complete }
    }
    
    private var completeOrders: [Order] {
        vm.orders.filter { $0.status == .complete }
    }
}
