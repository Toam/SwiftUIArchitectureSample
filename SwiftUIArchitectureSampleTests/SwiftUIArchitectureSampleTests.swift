//
//  SwiftUIArchitectureSampleTests.swift
//  SwiftUIArchitectureSampleTests
//
//  Created by Thomas Brelet on 14/04/2026.
//

import Foundation
import SwiftData
import Testing
@testable import SwiftUIArchitectureSample

@Suite(.serialized)
struct SwiftUIArchitectureSampleTests {

    @Test func todoItemUsesExpectedDefaultValues() {
        let item = TodoItem(title: "Write the first version")

        #expect(item.title == "Write the first version")
        #expect(item.details.isEmpty)
        #expect(item.dueDate != nil)
        #expect(item.isCompleted == false)
        #expect(item.isPriority == false)
    }

    @MainActor
    @Test func createTaskTrimsTitleAndInsertsIt() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let dueDate = Date(timeIntervalSince1970: 1_800_000_000)

        let item = try #require(TodoItemActions.createTask(
            title: "  Buy milk  ",
            details: "  Organic milk  ",
            dueDate: dueDate,
            isPriority: true,
            in: context
        ))
        let items = try fetchTodoItems(in: context)

        #expect(item.title == "Buy milk")
        #expect(item.details == "Organic milk")
        #expect(item.dueDate == dueDate)
        #expect(item.isPriority)
        #expect(items.map(\.title) == ["Buy milk"])
    }

    @MainActor
    @Test func createTaskIgnoresEmptyTitles() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        let item = TodoItemActions.createTask(title: "   ", in: context)
        let items = try fetchTodoItems(in: context)

        #expect(item == nil)
        #expect(items.isEmpty)
    }

    @Test func toggleCompletionUpdatesTaskState() {
        let item = TodoItem(title: "Finish the demo")

        TodoItemActions.toggleCompletion(for: item)

        #expect(item.isCompleted)
    }

    @Test func updateTaskTrimsAndUpdatesEditableFields() {
        let item = TodoItem(title: "Old title")
        let dueDate = Date(timeIntervalSince1970: 1_900_000_000)

        TodoItemActions.updateTask(
            item,
            title: "  New title  ",
            details: "  New description  ",
            dueDate: dueDate,
            isPriority: true
        )

        #expect(item.title == "New title")
        #expect(item.details == "New description")
        #expect(item.dueDate == dueDate)
        #expect(item.isPriority)
    }

    @Test func updateTaskIgnoresEmptyTitles() {
        let item = TodoItem(
            title: "Keep title",
            details: "Keep description",
            dueDate: Date(timeIntervalSince1970: 1_700_000_000)
        )
        let originalDueDate = item.dueDate

        TodoItemActions.updateTask(
            item,
            title: "   ",
            details: "New description",
            dueDate: Date(timeIntervalSince1970: 1_900_000_000),
            isPriority: true
        )

        #expect(item.title == "Keep title")
        #expect(item.details == "Keep description")
        #expect(item.dueDate == originalDueDate)
        #expect(item.isPriority == false)
    }

    @Test func todayItemsSortPriorityTasksFirst() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = Date()
        let normal = TodoItem(
            title: "Normal",
            dueDate: date,
            createdAt: date.addingTimeInterval(-10)
        )
        let priority = TodoItem(
            title: "Priority",
            dueDate: date.addingTimeInterval(10),
            isPriority: true,
            createdAt: date
        )

        let items = TodoItemFilters.todayItems(from: [normal, priority], calendar: calendar)

        #expect(items.map(\.title) == ["Priority", "Normal"])
    }

    @Test func todayItemsIncludeOverdueTasks() {
        let overdue = TodoItem(
            title: "Overdue",
            dueDate: Date().addingTimeInterval(-86_400)
        )

        let items = TodoItemFilters.todayItems(from: [overdue])

        #expect(items.map(\.title) == ["Overdue"])
    }

    @Test func futureItemsExcludeUnscheduledTasks() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let today = Date(timeIntervalSince1970: 1_800_000_000)
        let tomorrow = today.addingTimeInterval(86_400)
        let future = TodoItem(title: "Future", dueDate: tomorrow)
        let unscheduled = TodoItem(title: "No date", dueDate: nil)

        let items = TodoItemFilters.futureItems(from: [future, unscheduled], calendar: calendar, now: today)

        #expect(items.map(\.title) == ["Future"])
    }

    @MainActor
    @Test func createdTaskDueTodayIsVisibleInTodayItems() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        _ = try #require(TodoItemActions.createTask(
            title: "Today task",
            dueDate: .now,
            in: context
        ))
        let items = try fetchTodoItems(in: context)

        #expect(TodoItemFilters.todayItems(from: items).map(\.title) == ["Today task"])
    }

    @MainActor
    @Test func createdTaskDueTomorrowIsVisibleInFutureItems() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let tomorrow = try #require(Calendar.current.date(byAdding: .day, value: 1, to: .now))

        _ = try #require(TodoItemActions.createTask(
            title: "Tomorrow task",
            dueDate: tomorrow,
            in: context
        ))
        let items = try fetchTodoItems(in: context)

        #expect(TodoItemFilters.futureItems(from: items).map(\.title) == ["Tomorrow task"])
    }

    @MainActor
    @Test func createdTaskWithoutDateIsVisibleInUnscheduledItems() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        _ = try #require(TodoItemActions.createTask(
            title: "No date task",
            dueDate: nil,
            in: context
        ))
        let items = try fetchTodoItems(in: context)

        #expect(TodoItemFilters.unscheduledItems(from: items).map(\.title) == ["No date task"])
    }

    @MainActor
    @Test func createTaskSavesInsertedTaskToPersistence() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        context.autosaveEnabled = false

        _ = try #require(TodoItemActions.createTask(
            title: "Persist me",
            in: context
        ))
        let freshContext = ModelContext(container)

        #expect(try fetchTodoItems(in: freshContext).map(\.title) == ["Persist me"])
    }

    @MainActor
    @Test func deleteTaskRemovesItFromPersistence() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let item = try #require(TodoItemActions.createTask(title: "Remove me", in: context))

        TodoItemActions.delete(item, from: context)
        let items = try fetchTodoItems(in: context)

        #expect(items.isEmpty)
    }

    @MainActor
    @Test func seedDefaultTasksOnlyWhenStoreIsEmpty() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        try TodoItemActions.seedDefaultTasksIfNeeded(in: context)
        try TodoItemActions.seedDefaultTasksIfNeeded(in: context)
        let items = try fetchTodoItems(in: context)

        #expect(items.map(\.title) == ["My first task", "My second task"])
    }

    @MainActor
    private func makeModelContainer() throws -> ModelContainer {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(
            "Test-\(UUID().uuidString)",
            schema: schema,
            isStoredInMemoryOnly: true
        )

        return try ModelContainer(for: schema, configurations: [configuration])
    }

    @MainActor
    private func fetchTodoItems(in context: ModelContext) throws -> [TodoItem] {
        let descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\TodoItem.createdAt, order: .forward)]
        )

        return try context.fetch(descriptor)
    }
}
