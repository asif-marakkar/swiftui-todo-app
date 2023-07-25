//
//  ContentView.swift
//  Todo-App
//
//  Created by ASIF on 07/07/23.
//

import SwiftUI
import SwiftData
import Combine

struct ContentView: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @State private var taskSorting = TaskSorting.latest
    @State private var searchTerm = ""
    @State private var animate = false
    @State private var showAddTaskView = false
    
    @Query(filter: #Predicate<Task>{
        $0.completed == true 
    }, animation: .smooth) private var completedTasks: [Task]
    private var filteredTasks: [Task] {
        let predicate = searchTerm.isEmpty ? #Predicate<Task>{
            $0.completed == false
        } : #Predicate<Task>{
            $0.completed == false && $0.name.contains(searchTerm)
        }
        let descriptor = FetchDescriptor<Task>(predicate: predicate, sortBy: [taskSorting.sortDescriptor])
        return try! modelContext.fetch(descriptor)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        ForEach(filteredTasks) { task in
                            TaskRow(task: task)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                    deleteButton(task: task)
                                })
                        }
                    }
                    if !completedTasks.isEmpty {
                        Section("Completed (\(completedTasks.count))") {
                            ForEach(completedTasks) { task in
                                TaskRow(task: task)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                        deleteButton(task: task)
                                    })
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if filteredTasks.isEmpty && completedTasks.isEmpty {
                        Text("Oops! Looks like there is no data...")
                            .fontWeight(.heavy)
                    }
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
            .overlay(
                ZStack {
                  Group {
                    Circle()
                          .fill(Color.accentColor)
                      .opacity(animate ? 0.25 : 0)
                      .frame(width: 65, height: 65)
                    Circle()
                          .fill(Color.accentColor)
                      .opacity(animate ? 0.2 : 0)
                      .frame(width: 85, height: 85)
                  }
                  .animation(Animation.easeIn(duration: 1).repeatForever(), value: animate)
                  
                  Button(action: {
                      showAddTaskView.toggle()
                  }) {
                    Image(systemName: "plus.circle.fill")
                      .resizable()
                      .background(Circle().fill(Color.white))
                      .frame(width: 45, height: 45)
                  }
                  .onAppear(perform: {
                       animate.toggle()
                    })
                }
                .padding(.bottom, 16)
                .padding(.trailing, 16)
                , alignment: .bottomTrailing
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker(selection: $taskSorting) {
                            ForEach(TaskSorting.allCases) {
                                Text($0.title)
                            }
                        } label: {
                            Text("Sort by")
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .imageScale(.medium)
                    }
                }
            }
            .searchable(text: $searchTerm, prompt: Text("Search for tasks"))
            .navigationTitle("Todo App")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func deleteButton(task: Task) -> some View {
        Button(role: .destructive) {
            modelContext.delete(task)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}

enum TaskSorting: CaseIterable, Identifiable {
    case name, latest, oldest
    
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .latest:
            return "Latest"
        case .oldest:
            return "Oldest"
        }
    }
    
    var sortDescriptor: SortDescriptor<Task> {
        switch self {
        case .name:
            SortDescriptor(\.name, order: .forward)
        case .latest:
            SortDescriptor(\.createdAt, order: .reverse)
        case .oldest:
            SortDescriptor(\.createdAt, order: .forward)
        }
    }
    
    var id: Self {
        self
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
