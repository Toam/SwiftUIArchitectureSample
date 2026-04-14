//
//  TodoItemFilters.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import Foundation

enum TodoItemFilters {
    static func search(_ items: [TodoItem], text: String) -> [TodoItem] {
        let trimmedSearchText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return items
        }

        return items.filter { item in
            item.title.localizedStandardContains(trimmedSearchText)
        }
    }

    static func todayItems(from items: [TodoItem], calendar: Calendar = .current) -> [TodoItem] {
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: .now)) ?? .now

        return items
            .filter { item in
                guard let dueDate = item.dueDate else {
                    return false
                }

                return dueDate < startOfTomorrow
            }
            .sortedByPriorityAndDate()
    }

    static func futureItems(from items: [TodoItem], calendar: Calendar = .current, now: Date = .now) -> [TodoItem] {
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now

        return items
            .filter { item in
                guard let dueDate = item.dueDate else {
                    return false
                }

                return dueDate >= startOfTomorrow
            }
            .sortedByPriorityAndDate()
    }

    static func unscheduledItems(from items: [TodoItem]) -> [TodoItem] {
        items
            .filter { $0.dueDate == nil }
            .sortedByPriorityAndDate()
    }
}

extension Array where Element == TodoItem {
    func sortedByPriorityAndDate() -> [TodoItem] {
        sorted { lhs, rhs in
            if lhs.isPriority != rhs.isPriority {
                return lhs.isPriority
            }

            switch (lhs.dueDate, rhs.dueDate) {
            case let (lhsDate?, rhsDate?) where lhsDate != rhsDate:
                return lhsDate < rhsDate
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return lhs.createdAt < rhs.createdAt
            }
        }
    }
}
