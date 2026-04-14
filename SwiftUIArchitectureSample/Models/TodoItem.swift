//
//  TodoItem.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
    var title: String
    var details: String = ""
    var dueDate: Date?
    var isCompleted: Bool
    var isPriority: Bool
    var createdAt: Date

    init(
        title: String,
        details: String = "",
        dueDate: Date? = .now,
        isCompleted: Bool = false,
        isPriority: Bool = false,
        createdAt: Date = .now
    ) {
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.isPriority = isPriority
        self.createdAt = createdAt
    }
}
