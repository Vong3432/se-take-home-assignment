//
//  Orders.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import Foundation

class Orders: ObservableObject {
    @Published var orders = [Order]()
    @Published var bots = [Bot]()
    
    func createOrder(_ order: Order) {
        
        // Check if this order is for VIP
        let isVIP = order.isVIP
        
        // If it is not VIP, just append to orders list
        if !isVIP {
            orders.append(order)
            return
        }
        
        // If is vip,
        // check if there is any vip in list
        let idx = orders.lastIndex { $0.isVIP }
        guard let idx = idx else {
            // if no, insert to first
            orders.insert(order, at: 0)
            return
        }
        
        /// Insert new VIP order to behind last VIP order
        /// - If the last VIP order is the last item in list, just using append.
        /// - Otherwise, insert at idx + 1
        if idx != orders.count - 1 {
            orders.insert(order, at: idx + 1)
        } else {
            orders.append(order)
        }
    }
    
    private func markOrderCompleted(for order: Order, botIdx: Int) {
        let idx = orders.firstIndex { $0 == order }
        
        // make sure the bot that process the current order exist,
        // and the order that is going to be marked as completed is still the same that the bot handle previously.
        guard let idx = idx, bots[safe: botIdx] != nil, bots[botIdx].order == order else { return }
        
        bots[botIdx].order = nil
        orders[idx].status = .complete
    }
    
    func addBot() {
        bots.append(Bot(order: nil))
    }
    
    func removeBot() {
        guard bots.isEmpty == false else { return }
        
        let _ = bots.removeLast()
    }
    
    /// A function that keep tracking on whether there are any pending orders to be processed.
    ///
    /// Possible optimization & concerns:
    ///  - Using a local timer way to update status may cause data race issue if there are other places in the app that will access to the `orders` list.
    ///  - Maybe a better way to handle this kind of situation is to implement a real-time communication technology (e.g: Websocket, Pusher), where the server will handle the order status logic, and the app will be listening to the events from the server and update the `orders` list accordingly.
    ///  - Without real-time communication technology and handle the order status in app only, it might cause data inconsistensy issue. For instance, userA may see different results on different devices. 
    func processOrder() {
        let pendingOrders = orders.filter { $0.status == .pending }
        
        // make sure got bots, and got pending orders
        guard bots.isEmpty == false, pendingOrders.isEmpty == false else { return }
        
        // get the available bot that is not processing order or is processing non-VIP order
        let botIdx = bots.firstIndex { $0.order == nil || $0.order?.isVIP == false }
        
        guard let botIdx = botIdx, let order = pendingOrders.first else {
            return
        }
        
        // assign order to the bot
        bots[botIdx].order = pendingOrders.first
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.markOrderCompleted(for: order, botIdx: botIdx)
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
