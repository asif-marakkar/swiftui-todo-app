//
//  Todo.swift
//  Todo-App
//
//  Created by ASIF on 07/07/23.
//

import SwiftUI
import SwiftData

typealias TodoSchema = TodoSchemaV3
typealias Task = TodoSchema.Task
typealias Note = TodoSchema.Note

// MARK: - Version 1
enum TodoSchemaV1: VersionedSchema {
    static var versionIdentifier: String? = "v1"
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }
    
    @Model
    final class Task {
        @Attribute(.unique) var id: UUID
        var name: String
        
        init(id: UUID, name: String) {
            self.id = id
            self.name = name
        }
    }
}

// MARK: - Version 2
enum TodoSchemaV2: VersionedSchema {
    static var versionIdentifier: String? = "v2"
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }
    
    @Model
    final class Task {
        @Attribute(.unique) var id: UUID
        var name: String
        var priority: String = Priority.low.rawValue
        
        init(id: UUID, name: String, priority: String) {
            self.id = id
            self.name = name
            self.priority = priority
        }
    }
}

// MARK: - Version 3
enum TodoSchemaV3: VersionedSchema {
    static var versionIdentifier: String? = "v3"
    static var models: [any PersistentModel.Type] {
        [Task.self, Note.self]
    }
    
    @Model
    final class Task: Identifiable {
        @Attribute(.unique) var id: UUID
        var name: String
        var priority: String = Priority.low.rawValue
        var completed: Bool = false
        var createdAt: Date
        @Relationship(.cascade) var note: Note?
        
        init(id: UUID, name: String, priority: String, createdAt: Date, note: Note? = nil) {
            self.id = id
            self.name = name
            self.priority = priority
            self.createdAt = createdAt
            self.note = note
        }
    }
    
    @Model
    final class Note {
        var details: String?
        
        init(details: String? = nil) {
            self.details = details
        }
    }
}
