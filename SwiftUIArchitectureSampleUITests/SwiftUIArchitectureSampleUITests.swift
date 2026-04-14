//
//  SwiftUIArchitectureSampleUITests.swift
//  SwiftUIArchitectureSampleUITests
//
//  Created by Thomas Brelet on 14/04/2026.
//

import XCTest

final class SwiftUIArchitectureSampleUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCreateCompleteSearchAndDeleteTask() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        XCTAssertTrue(app.staticTexts["My first task"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Later"].tap()
        XCTAssertTrue(app.staticTexts["My second task"].exists)

        app.tabBars.buttons["Today"].tap()
        app.buttons["add-task-button"].tap()

        let taskNameField = app.textFields["task-name-field"]
        XCTAssertTrue(taskNameField.waitForExistence(timeout: 2))
        taskNameField.tap()
        taskNameField.typeText("Read SwiftData docs")

        let descriptionField = app.textFields["task-description-field"]
        XCTAssertTrue(descriptionField.exists)
        descriptionField.tap()
        descriptionField.typeText("Cover creation, completion, search, and deletion.")

        app.buttons["Add"].tap()

        let createdTask = app.staticTexts["Read SwiftData docs"]
        XCTAssertTrue(createdTask.waitForExistence(timeout: 2))

        app.buttons["todo-row-Read SwiftData docs"].tap()
        let detailDescriptionField = app.textFields["task-detail-description-field"]
        XCTAssertTrue(detailDescriptionField.waitForExistence(timeout: 2))
        XCTAssertEqual(detailDescriptionField.value as? String, "Cover creation, completion, search, and deletion.")
        app.buttons["Done"].tap()

        app.buttons["todo-toggle-Read SwiftData docs"].tap()
        XCTAssertTrue(app.buttons["todo-toggle-Read SwiftData docs"].waitForExistence(timeout: 2))

        let searchField = app.searchFields["Search tasks"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("Read SwiftData")

        XCTAssertTrue(createdTask.waitForExistence(timeout: 2))
        XCTAssertFalse(app.staticTexts["My first task"].exists)

        createdTask.swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertFalse(createdTask.waitForExistence(timeout: 2))
    }
}
