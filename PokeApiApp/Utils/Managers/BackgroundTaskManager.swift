//
//  BackgroundTaskManager.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation
import BackgroundTasks
import UserNotifications

//MARK: MANAGER DE BACKGROUND TASK (OPERACIONES EN SEGUNDO PLANO)
class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private init() {}

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.refreshData", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.PokeApiApp.refreshData")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        executeOperation(task: task, operation: PokemonRefreshOperation())
    }
    
    private func executeOperation(task: BGTask, operation: Operation) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }

        queue.addOperation(operation)
    }
}
