//
//  Bot.swift
//  se
//
//  Created by Vong Nyuksoon on 07/09/2022.
//

import Foundation

class Bot: Identifiable {
    let id: String?
    private(set)var order: Order?
    private var task: Task<Void, Never>?
    
    let queue: DispatchQueue!
    
    init(id: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.queue = DispatchQueue(label: self.id!)
    }
    
    func assignOrder(order: Order) {
        self.order = order
    }
    
    func process() async {
        guard self.order != nil else { return }
        
        queue.async { [self] in
            order?.status = .processing
            
            task = Task {
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                
                if Task.isCancelled { return }
                
                order?.status = .complete
                task = nil
                order = nil
            }
        }
    }
    
    func cancel() {
        order?.status = .pending
        
        queue.async {
            self.task?.cancel()
        }
    }
}
