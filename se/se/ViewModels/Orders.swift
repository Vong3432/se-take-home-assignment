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
    
    func addBot() {
        bots.append(Bot(id: UUID().uuidString))
    }
    
    func removeBot() {
        guard bots.isEmpty == false, let lastBot = bots.last else { return }
        lastBot.cancel()
        bots.removeLast()
        
    }
    
    /// A function that keep tracking on whether there are any pending orders to be processed.
    ///
    /// Possible optimization & concerns:
    ///  - Using a local timer way to update status may cause data race issue if there are other places in the app that will access to the `orders` list.
    ///  - Maybe a better way to handle this kind of situation is to implement a real-time communication technology (e.g: Websocket, Pusher), where the server will handle the order status logic, and the app will be listening to the events from the server and update the `orders` list accordingly.
    ///  - Without real-time communication technology and handle the order status in app only, it might cause data inconsistensy issue. For instance, userA may see different results on different devices.
    func processOrder() {
        let pendingOrders = orders.filter { $0.status == .pending }
        
        guard bots.isEmpty == false, pendingOrders.isEmpty == false, let order = pendingOrders.first else { return }
        
        // get free bot
        let bot = bots.first { bot in
            let isEmptyOrder = bot.order == nil
            let isNonVipOrder = bot.order?.isVIP == false
            
            return isEmptyOrder || (isNonVipOrder && order.isVIP)
        }
        
        guard let bot = bot else { return }
        
        // reset if bot is handling non-VIP orders before
        if bot.order?.isVIP == false && order.isVIP {
            bot.cancel()
        }
        
        // assign order to the bot
        bot.assignOrder(order: order)
        bot.process()
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
