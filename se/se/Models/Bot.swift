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
        self.order?.status = .pending
        self.order = order
    }
    
    func process() {
        guard self.order != nil else { return }
        
        Task {
            await MainActor.run {
                order?.status = .processing
            }
        }
        
        queue.async { [self] in
            task = Task {
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    order?.status = .complete
                    order = nil
                }
            }
        }
    }
    
    func cancel() {
        Task {
            await MainActor.run {
                order?.status = .pending
            }
        }

        queue.async { [self] in            
            task?.cancel()
            task = nil
        }
    }
}
