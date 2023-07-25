//
//  TodoItem.swift
//  Todo-App
//
//  Created by ASIF on 11/07/23.
//

import SwiftUI

struct TaskRow: View {
    
    // MARK: - Properties
    @Bindable var task: Task
    
    // MARK: - Body
    var body: some View {
        let color = colorize(priority: task.priority)
        HStack {
            Toggle(isOn: $task.completed, label: {
                Text(task.name)
                    .fontWeight(.regular)
                    .strikethrough(task.completed)
            })
            .toggleStyle(.checkmark)
            Spacer()
            Text(task.priority)
                .padding(3)
                .frame(minWidth: 60)
                .font(.footnote)
                .foregroundStyle(color)
                .overlay(Capsule().stroke(color, lineWidth: 0.7))
        }
    }
    
    // MARK: - Color based on Todo priority
    private func colorize(priority: String) -> Color {
        switch priority.capitalized {
      case Priority.high.rawValue: return .red
      case Priority.normal.rawValue: return .green
      case Priority.low.rawValue: return .blue
      default: return .gray
      }
    }
}
