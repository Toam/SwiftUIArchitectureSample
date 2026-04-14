//
//  AddTaskSheet.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftData
import SwiftUI

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @FocusState private var isTitleFocused: Bool
    @State private var title: String
    @State private var details: String
    @State private var hasDueDate: Bool
    @State private var dueDate: Date
    @State private var isPriority: Bool

    init(hasDueDate: Bool = true, dueDate: Date = .now, isPriority: Bool = false) {
        _title = State(initialValue: "")
        _details = State(initialValue: "")
        _hasDueDate = State(initialValue: hasDueDate)
        _dueDate = State(initialValue: dueDate)
        _isPriority = State(initialValue: isPriority)
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task name", text: $title)
                        .focused($isTitleFocused)
                        .submitLabel(.done)
                        .onSubmit(addTask)
                        .accessibilityIdentifier("task-name-field")

                    TextField("Description", text: $details, axis: .vertical)
                        .lineLimit(3...6)
                        .accessibilityIdentifier("task-description-field")

                    Toggle("Priority", isOn: $isPriority)
                        .accessibilityIdentifier("task-priority-toggle")

                    Toggle("Set Date", isOn: $hasDueDate)
                        .accessibilityIdentifier("task-has-date-toggle")

                    if hasDueDate {
                        DatePicker("Date", selection: $dueDate, displayedComponents: .date)
                            .accessibilityIdentifier("task-date-picker")
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: addTask)
                        .disabled(trimmedTitle.isEmpty)
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
    }

    private func addTask() {
        guard !trimmedTitle.isEmpty else {
            return
        }

        if TodoItemActions.createTask(
            title: trimmedTitle,
            details: details,
            dueDate: hasDueDate ? dueDate : nil,
            isPriority: isPriority,
            in: modelContext
        ) != nil {
            dismiss()
        }
    }
}

#Preview {
    AddTaskSheet()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
