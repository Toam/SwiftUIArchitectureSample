# SwiftUI Architecture Sample

A small iOS todo app used to demonstrate a simple, native SwiftUI architecture.

The project intentionally stays focused on Apple frameworks and clear SwiftUI patterns:

- SwiftUI for the full user interface
- SwiftData for persistence
- Swift Testing for unit tests
- XCTest for UI tests
- No third-party UI or architecture frameworks

## Features

- List tasks
- Search tasks
- Create tasks with a title, description, and date
- Edit task details from the detail sheet
- Mark tasks as completed
- Delete tasks with swipe actions

## Structure

- `Models`: SwiftData models and task actions
- `Views/TodoList`: task list screen and row components
- `Views/TaskForm`: creation and detail editing sheets
- `SwiftUIArchitectureSampleTests`: Swift Testing coverage for task use cases
- `SwiftUIArchitectureSampleUITests`: a basic end-to-end UI flow
