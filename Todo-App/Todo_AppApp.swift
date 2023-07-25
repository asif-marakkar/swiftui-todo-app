//
//  Todo_AppApp.swift
//  Todo-App
//
//  Created by ASIF on 07/07/23.
//

import SwiftUI
import SwiftData

@main
struct Todo_AppApp: App {
    var container: ModelContainer
    
    init() {
        let schema = Schema([Task.self, Note.self])
        let documentPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        let storePath = documentPath + "/todo.store"
        let configuration = ModelConfiguration(url: .init(filePath: storePath))
        container = try! ModelContainer(for: schema, migrationPlan: MigrationPlan.self, configuration)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
