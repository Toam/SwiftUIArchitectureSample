//
//  SettingsView.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .forward) private var todoItems: [TodoItem]

    @State private var isDeleteConfirmationPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Tasks") {
                    Button("Delete Completed Tasks", role: .destructive) {
                        isDeleteConfirmationPresented = true
                    }
                    .disabled(!todoItems.contains { $0.isCompleted })
                }

                Section("About") {
                    LabeledContent("Architecture", value: "SwiftUI + SwiftData")
                    LabeledContent("Tasks", value: "\(todoItems.count)")
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Are you sure you want to delete task ?",
                isPresented: $isDeleteConfirmationPresented,
                titleVisibility: .visible
            ) {
                Button("Yes", role: .destructive) {
                    deleteCompletedTasks()
                }

                Button("No", role: .cancel) { }
            }
        }
    }

    private func deleteCompletedTasks() {
        withAnimation {
            todoItems
                .filter(\.isCompleted)
                .forEach { item in
                    TodoItemActions.delete(item, from: modelContext)
                }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(TodoListPreviewData.modelContainer)
}
