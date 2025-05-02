//
//  AppDelegate.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 30/4/25.
//
import UIKit
import BackgroundTasks
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pokemon") // Reemplaza "TuModeloDeDatos"
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.PokeApiApp.refreshData",
                                        using: DispatchQueue.global(qos: .background)) { task in
            if let refreshTask = task as? BGAppRefreshTask {
                self.handleBackgroundFetch(task: refreshTask)
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundFetch()
    }
    
    func scheduleBackgroundFetch() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.PokeApiApp.refreshData")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("No se pudo programar la tarea de background fetch: \(error)")
        }
    }
    
    func handleBackgroundFetch(task: BGAppRefreshTask) {
        print("⏳ Iniciando background fetch de Pokémon...")
        task.expirationHandler = {
            print("⚠️ El tiempo de background fetch expiró.")
            task.setTaskCompleted(success: false)
        }
        
        let context = persistentContainer.newBackgroundContext()
        let viewModel = PokemonMainViewModel(viewContext: context)
        
        Task { @MainActor in
            let initialCount = viewModel.detailPokemon.count
            //await viewModel.fetchNewPokemonsInBackground()
            let newCount = viewModel.detailPokemon.count
            
            if newCount > initialCount {
                print("✅ Se encontraron \(newCount - initialCount) nuevos Pokémon en segundo plano.")
                task.setTaskCompleted(success: true)
            } else {
                print("ℹ️ No se encontraron nuevos Pokémon en segundo plano.")
                task.setTaskCompleted(success: true)
            }
        }
    }
}
