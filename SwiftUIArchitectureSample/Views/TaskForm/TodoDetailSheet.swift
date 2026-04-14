//
//  TodoDetailSheet.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoDetailSheet: View {
    @Environment(\.dismiss) private var dismiss

    let item: TodoItem

    @FocusState private var isTitleFocused: Bool
    @State private var title: String
    @State private var details: String
    @State private var hasDueDate: Bool
    @State private var dueDate: Date
    @State private var isPriority: Bool

    init(item: TodoItem) {
        self.item = item
        _title = State(initialValue: item.title)
        _details = State(initialValue: item.details)
        _hasDueDate = State(initialValue: item.dueDate != nil)
        _dueDate = State(initialValue: item.dueDate ?? .now)
        _isPriority = State(initialValue: item.isPriority)
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Task name", text: $title)
                        .focused($isTitleFocused)
                        .submitLabel(.done)
                        .onSubmit(saveTask)
                        .accessibilityIdentifier("task-detail-title-field")

                    Label(
                        item.isCompleted ? "Completed" : "Not completed",
                        systemImage: item.isCompleted ? "checkmark.circle.fill" : "circle"
                    )

                    Toggle("Priority", isOn: $isPriority)
                        .accessibilityIdentifier("task-detail-priority-toggle")
                }

                Section("Description") {
                    TextField("Description", text: $details, axis: .vertical)
                        .lineLimit(3...6)
                        .accessibilityIdentifier("task-detail-description-field")
                }

                Section("Date") {
                    Toggle("Set Date", isOn: $hasDueDate)
                        .accessibilityIdentifier("task-detail-has-date-toggle")

                    if hasDueDate {
                        DatePicker("Date", selection: $dueDate, displayedComponents: .date)
                            .accessibilityIdentifier("task-detail-date-picker")
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: saveTask)
                        .disabled(trimmedTitle.isEmpty)
                }
            }
        }
    }

    private func saveTask() {
        guard !trimmedTitle.isEmpty else {
            return
        }

        TodoItemActions.updateTask(
            item,
            title: title,
            details: details,
            dueDate: hasDueDate ? dueDate : nil,
            isPriority: isPriority
        )
        dismiss()
    }
}

#Preview {
    TodoDetailSheet(
        item: TodoItem(
            title: "Review SwiftUI architecture",
            details: "Keep the view structure simple and native.",
            dueDate: .now,
            isCompleted: true,
            isPriority: true
        )
    )
}
