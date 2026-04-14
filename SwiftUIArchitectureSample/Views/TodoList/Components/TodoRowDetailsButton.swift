//
//  TodoRowDetailsButton.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoRowDetailsButton: View {
    let item: TodoItem
    let action: () -> Void

    private var formattedDueDate: String {
        item.dueDate?.formatted(date: .abbreviated, time: .omitted) ?? "No date"
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(item.title)
                        .fontWeight(item.isPriority ? .semibold : .regular)
                        .strikethrough(item.isCompleted)
                        .foregroundStyle(item.isCompleted ? .secondary : .primary)
                        .accessibilityIdentifier("todo-title-\(item.title)")

                    if item.isPriority {
                        Label("Priority", systemImage: "exclamationmark.circle.fill")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(.orange)
                            .accessibilityLabel("Priority")
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(formattedDueDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !item.details.isEmpty {
                    Text(item.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .accessibilityLabel(item.isPriority ? "Show details for priority task \(item.title)" : "Show details for \(item.title)")
        .accessibilityIdentifier("todo-row-\(item.title)")
    }
}
