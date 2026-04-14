//
//  TodoRow.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoRow: View {
    let item: TodoItem
    let toggleCompletion: () -> Void
    let delete: () -> Void
    let showDetails: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TodoToggleButton(item: item, action: toggleCompletion)

            TodoRowDetailsButton(item: item, action: showDetails)
        }
        .padding(.vertical, 8)
        .listRowBackground(item.isPriority ? Color.yellow.opacity(0.12) : nil)
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive, action: delete)
                .accessibilityIdentifier("delete-\(item.title)")
        }
    }
}
