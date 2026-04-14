# Agents

## Repository Goal

This repository is a SwiftUI architecture demo for an iOS application.

The main goal is to demonstrate a clear, simple architecture focused on SwiftUI best practices, using only native iOS components.

## Constraints

- Do not add external frameworks.
- Do not use MVVM or other architecture frameworks.
- Use SwiftData for persistence to stay on the most recent native technology.
- Use Swift Testing for tests.
- Keep the implementation extremely simple.
- Prioritize readability, separation of responsibilities, and native SwiftUI patterns.
- Avoid unnecessary abstractions while the need remains simple.

## Target Application

The demo application is a simple todo app.

Expected features:

- Display a list of tasks.
- Allow checking a task to mark it as completed.
- Allow creating a new task.
- Persist tasks with SwiftData.

## Screens

### Home Screen

The home screen contains:

- A search bar at the top.
- A list of tasks.
- For each task row:
  - a checkbox as the first element;
  - the task content after it.
- A large floating button in the bottom-right corner to add a task.

### Add Task

The add button opens a sheet.

The sheet allows entering the name of the new task.

## Persistence

Persistence must be implemented with SwiftData.

The model must remain simple:

- one object representing a task;
- only the fields strictly necessary to display, search, check, and create tasks.

## SwiftUI Principles

- Prefer small, readable, composable views.
- Keep state at the lowest possible level.
- Use native SwiftUI and SwiftData tools when they are enough: `@State`, `@Binding`, `@Environment`, `@Query`, `@Model`.
- Avoid adding a view model by reflex if the view and SwiftData can keep the code simple and testable.
- Do not recreate a heavy UIKit or MVVM architecture in a small SwiftUI app.
- Extract components only when it truly improves readability or avoids concrete duplication.

## Expected Structure

The project structure must remain simple and explicit.

- SwiftData models should be grouped in a dedicated models area.
- SwiftUI screens should be separated from reusable components when it makes the code easier to read.
- Tests must use Swift Testing.
- Preview helpers can be added if they make views easier to read or validate.

## Expected Quality

- Use explicit and consistent naming.
- Keep files short when possible.
- Remove dead code and unused abstractions.
- Add useful SwiftUI previews for main views.
- Test non-trivial logic with Swift Testing.
- Keep changes focused on the current need.

## Accessibility

- Provide VoiceOver labels for important actions.
- Support Dynamic Type as much as possible with native SwiftUI components.
- Keep tap targets large enough for interactive actions.
- Make sure important visual states do not rely on color alone.

## Architecture Direction

Future changes must stay aligned with the repository goal: a native, simple, clean SwiftUI demo.

Each addition must be justified by a concrete need in the todo app or by improved architecture readability.

If a simpler native solution can address the need, it should be preferred.
