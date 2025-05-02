//
//  AppDelegate.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//

import UIKit
import BackgroundTasks
import UserNotifications

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("Error al solicitar notificaciones:", error.localizedDescription)
//            }
//        }
//        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.refreshData", using: nil) { task in
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//            
//        }
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.processing", using: nil) { task in
//            self.handleProcessing(task: task as! BGProcessingTask)
//        }
//        
//        scheduleAppRefresh()
//        scheduleProcessing()
//        
//        return true
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        
//    }
//    
//    func scheduleAppRefresh() {
//        let request = BGAppRefreshTaskRequest(identifier: "com.example.PokeApiApp.refreshData")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("No se pudo programar BGAppRefreshTask:", error)
//        }
//    }
//    
//    func scheduleProcessing() {
//        let request = BGProcessingTaskRequest(identifier: "com.example.PokeApiApp.processing")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
//        request.requiresNetworkConnectivity = true
//        request.requiresExternalPower = false
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule processing: \(error)")
//        }
//    }
//    
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        scheduleAppRefresh()
//        
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        
//        let operation = PokemonRefreshOperation()
//        
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//        
//        operation.completionBlock = {
//            task.setTaskCompleted(success: !operation.isCancelled)
//        }
//        
//        queue.addOperation(operation)
//    }
//    
//    func handleProcessing(task: BGProcessingTask) {
//        scheduleProcessing()
//        
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        
//        let operation = PokemonProcessingOperation()
//        
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//        
//        operation.completionBlock = {
//            task.setTaskCompleted(success: !operation.isCancelled)
//        }
//        
//        queue.addOperation(operation)
//    }
//    
//    
//    
//    //        func sendLocalNotification() {
//    //            let content = UNMutableNotificationContent()
//    //            content.title = "Pokédex actualizada"
//    //            content.body = "Se agregaron 5 nuevos Pokémon mientras estabas fuera"
//    //            content.sound = .default
//    //
//    //            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//    //            UNUserNotificationCenter.current().add(request)
//    //        }
//}
//
//class PokemonRefreshOperation: Operation {
//    override func main() {
//        let context = PersistenceController.shared.container.viewContext
//        let viewModel = PokemonMainViewModel(viewContext: context)
//        
//        let semaphore = DispatchSemaphore(value: 0)
//        
//        Task {
//            await viewModel.getFiveNewPokemonsForBackgroundFetch()
//            scheduleLocalNotification()
//            semaphore.signal()
//        }
//        
//        semaphore.wait()
//    }
//    
//    func scheduleLocalNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Pokédex actualizada"
//        content.body = "Se agregaron 5 nuevos Pokémon en segundo plano."
//        content.sound = .default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//    }
//}
//
//class PokemonProcessingOperation: Operation {
//    override func main() {
//        let context = PersistenceController.shared.container.viewContext
//        let viewModel = PokemonMainViewModel(viewContext: context)
//        
//        let semaphore = DispatchSemaphore(value: 0)
//        
//        Task {
//            await viewModel.getFiveNewPokemonsForBackgroundFetch()
//            scheduleLocalNotification()
//            semaphore.signal()
//        }
//        
//        semaphore.wait()
//    }
//    
//    func scheduleLocalNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Pokédex actualizada (Procesamiento)"
//        content.body = "Se agregaron 5 nuevos Pokémon en background con procesamiento."
//        content.sound = .default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//    }
//}
