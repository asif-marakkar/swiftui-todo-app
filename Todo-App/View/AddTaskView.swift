//
//  AddTodoView.swift
//  Todo-App
//
//  Created by ASIF on 07/07/23.
//

import SwiftUI
import SwiftData

enum Priority: String, CaseIterable {
    case low = "Low", normal = "Normal", high = "High"
}

struct AddTaskView: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var taskName: String = ""
    @State private var taskDetails: String = ""
    @State private var priority: Priority = .normal
    private let priorities = Priority.allCases
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 24) {
                    TextField("New task", text: $taskName)
                        .modifier(LabelModifier(color: Color(uiColor: UIColor.secondarySystemFill)))
                    TextField("Add details", text: $taskDetails)
                        .modifier(LabelModifier(color: Color(uiColor: UIColor.secondarySystemFill)))
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    Button(action: onSave, label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .modifier(LabelModifier(color: .accentColor))
                            .foregroundColor(Color.white)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 32)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                      dismiss()
                    }) {
                      Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Save Button Clicked
    private func onSave() {
        let name = taskName.trimmingCharacters(in: .whitespaces)
        let details = taskDetails.trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            return
        }
        let task = Task(id: UUID(), name: name, priority: priority.rawValue, createdAt: .now)
        if !details.isEmpty {
            task.note = Note(details: details)
        }
        modelContext.insert(task)
        dismiss()
    }
}

// MARK: - Label common modifier
struct LabelModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.system(size: 25, weight: .bold, design: .rounded))
    }
}

#Preview {
    AddTaskView()
}
