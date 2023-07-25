//
//  MigrationPlan.swift
//  Todo-App
//
//  Created by ASIF on 07/07/23.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [TodoSchemaV1.self, TodoSchemaV2.self, TodoSchemaV3.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV3]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(fromVersion: TodoSchemaV1.self, toVersion: TodoSchemaV2.self)
    
    static let migrateV2toV3 = MigrationStage.lightweight(fromVersion: TodoSchemaV2.self, toVersion: TodoSchemaV3.self)
}
