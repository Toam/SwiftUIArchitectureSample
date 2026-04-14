//
//  TodoItemActions.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import Foundation
import SwiftData

enum TodoItemActions {
    static let defaultTaskTitles = [
        "My first task",
        "My second task"
    ]

    @discardableResult
    static func createTask(
        title: String,
        details: String = "",
        dueDate: Date? = .now,
        isPriority: Bool = false,
        in context: ModelContext
    ) -> TodoItem? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return nil
        }

        let item = TodoItem(
            title: trimmedTitle,
            details: trimmedDetails,
            dueDate: dueDate,
            isPriority: isPriority
        )
        context.insert(item)

        do {
            try context.save()
        } catch {
            context.delete(item)
            return nil
        }

        return item
    }

    static func toggleCompletion(for item: TodoItem) {
        item.isCompleted.toggle()
    }

    static func updateTask(
        _ item: TodoItem,
        title: String,
        details: String,
        dueDate: Date?,
        isPriority: Bool
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            return
        }

        item.title = trimmedTitle
        item.details = trimmedDetails
        item.dueDate = dueDate
        item.isPriority = isPriority
    }

    static func delete(_ item: TodoItem, from context: ModelContext) {
        context.delete(item)
    }

    static func seedDefaultTasksIfNeeded(in context: ModelContext) throws {
        let existingItems = try context.fetch(FetchDescriptor<TodoItem>())

        guard existingItems.isEmpty else {
            return
        }

        createTask(title: defaultTaskTitles[0], isPriority: true, in: context)
        createTask(
            title: defaultTaskTitles[1],
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: .now),
            in: context
        )
    }
}
