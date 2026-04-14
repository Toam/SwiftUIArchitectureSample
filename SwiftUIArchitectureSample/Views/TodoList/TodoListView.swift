//
//  TodoListView.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftData
import SwiftUI

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .forward) private var todoItems: [TodoItem]

    @State private var searchText = ""
    @State private var isAddTaskPresented = false
    @State private var selectedItem: TodoItem?
    @State private var selectionFeedbackTrigger = 0

    private var todayItems: [TodoItem] {
        TodoItemFilters.todayItems(
            from: TodoItemFilters.search(todoItems, text: searchText)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                TodoListContent(
                    todoItems: todayItems,
                    searchText: searchText,
                    toggleCompletion: toggleCompletion,
                    delete: delete,
                    showDetails: showDetails
                )

                FloatingAddTaskButton {
                    isAddTaskPresented = true
                }
            }
            .navigationTitle("Today")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search tasks"
            )
            .sheet(isPresented: $isAddTaskPresented) {
                AddTaskSheet(hasDueDate: true, dueDate: .now)
            }
            .sheet(item: $selectedItem) { item in
                TodoDetailSheet(item: item)
            }
            .task {
                try? TodoItemActions.seedDefaultTasksIfNeeded(in: modelContext)
            }
            .sensoryFeedback(.selection, trigger: selectionFeedbackTrigger)
        }
    }

    private func toggleCompletion(for item: TodoItem) {
        withAnimation {
            TodoItemActions.toggleCompletion(for: item)
            selectionFeedbackTrigger += 1
        }
    }

    private func delete(_ item: TodoItem) {
        withAnimation {
            TodoItemActions.delete(item, from: modelContext)
        }
    }

    private func showDetails(for item: TodoItem) {
        selectionFeedbackTrigger += 1
        selectedItem = item
    }
}

#Preview {
    TodoListView()
        .modelContainer(TodoListPreviewData.modelContainer)
}

enum TodoListPreviewData {
    @MainActor
    static let modelContainer: ModelContainer = {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        container.mainContext.insert(TodoItem(
            title: "Review SwiftUI architecture",
            details: "Keep the view structure simple and native.",
            isPriority: true
        ))
        container.mainContext.insert(TodoItem(
            title: "Add SwiftData persistence",
            details: "Use SwiftData directly from SwiftUI views.",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: .now),
            isCompleted: true
        ))
        container.mainContext.insert(TodoItem(
            title: "Write Swift Testing coverage",
            details: "Cover task creation, completion, and deletion.",
            dueDate: nil
        ))

        return container
    }()
}
