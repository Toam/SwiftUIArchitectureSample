//
//  LaterTasksView.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftData
import SwiftUI

struct LaterTasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .forward) private var todoItems: [TodoItem]

    @State private var searchText = ""
    @State private var isAddTaskPresented = false
    @State private var selectedItem: TodoItem?
    @State private var selectionFeedbackTrigger = 0

    private var futureItems: [TodoItem] {
        TodoItemFilters.futureItems(
            from: TodoItemFilters.search(todoItems, text: searchText)
        )
    }

    private var unscheduledItems: [TodoItem] {
        TodoItemFilters.unscheduledItems(
            from: TodoItemFilters.search(todoItems, text: searchText)
        )
    }

    private var groupedFutureItems: [(date: Date, items: [TodoItem])] {
        Dictionary(grouping: futureItems) { item in
            Calendar.current.startOfDay(for: item.dueDate ?? .now)
        }
        .map { date, items in
            (date, items.sortedByPriorityAndDate())
        }
        .sorted { lhs, rhs in
            lhs.date < rhs.date
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(groupedFutureItems, id: \.date) { group in
                        Section(group.date.formatted(date: .complete, time: .omitted)) {
                            ForEach(group.items) { item in
                                TodoRow(item: item) {
                                    toggleCompletion(for: item)
                                } delete: {
                                    delete(item)
                                } showDetails: {
                                    showDetails(for: item)
                                }
                            }
                        }
                    }

                    if !unscheduledItems.isEmpty {
                        Section("No Date") {
                            ForEach(unscheduledItems) { item in
                                TodoRow(item: item) {
                                    toggleCompletion(for: item)
                                } delete: {
                                    delete(item)
                                } showDetails: {
                                    showDetails(for: item)
                                }
                            }
                        }
                    }
                }
                .overlay {
                    if groupedFutureItems.isEmpty && unscheduledItems.isEmpty {
                        emptyState
                    }
                }

                FloatingAddTaskButton {
                    isAddTaskPresented = true
                }
            }
            .navigationTitle("Later")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search tasks"
            )
            .sheet(isPresented: $isAddTaskPresented) {
                AddTaskSheet(hasDueDate: false, dueDate: .now)
            }
            .sheet(item: $selectedItem) { item in
                TodoDetailSheet(item: item)
            }
            .sensoryFeedback(.selection, trigger: selectionFeedbackTrigger)
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if searchText.isEmpty {
            ContentUnavailableView(
                "No Later Tasks",
                systemImage: "calendar",
                description: Text("Tasks scheduled after today or without a date will appear here.")
            )
        } else {
            ContentUnavailableView.search(text: searchText)
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
    LaterTasksView()
        .modelContainer(TodoListPreviewData.modelContainer)
}
