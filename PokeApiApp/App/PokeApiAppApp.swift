//
//  PokeApiAppApp.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 29/4/25.
//
import SwiftUI

@main
struct PokeApiAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var myAppManager = MyAppManager.shared
    @StateObject private var persistenceController = PersistenceController.shared
    
    init() {
        NotificationManager.shared.requestAuthorization()
        BackgroundTaskManager.shared.registerBackgroundTasks()
    }
    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environmentObject(myAppManager)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear {
                        BackgroundTaskManager.shared.scheduleAppRefresh()
                    }
                    .onChange(of: scenePhase) { newPhase in
                        switch newPhase {
                        case .background:
                            BackgroundTaskManager.shared.scheduleAppRefresh()
                        default:
                            break
                        }
                    }
        }
    }
}

