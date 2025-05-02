//
//  BackgroundTaskManager.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 2/5/25.
//

import Foundation
import BackgroundTasks
import UserNotifications

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private init() {}

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.refreshData", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.processing", using: nil) { task in
            self.handleProcessing(task: task as! BGProcessingTask)
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.PokeApiApp.refreshData")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    func scheduleProcessing() {
        let request = BGProcessingTaskRequest(identifier: "com.example.PokeApiApp.processing")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        try? BGTaskScheduler.shared.submit(request)
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        executeOperation(task: task, operation: PokemonRefreshOperation())
    }

    private func handleProcessing(task: BGProcessingTask) {
        scheduleProcessing()
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
