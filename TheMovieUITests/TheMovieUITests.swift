//
//  TheMovieUITests.swift
//  TheMovieUITests
//
//  Created by Aguscahyo on 14/01/26.
//

import XCTest

final class TheMovieUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSmokeFlow() throws {
        // 1. Launch App
        let app = XCUIApplication()
        app.launch()
        
        // 2. Verify List Screen
        let movieList = app.scrollViews["movie_list"]
        XCTAssertTrue(movieList.waitForExistence(timeout: 5), "Movie List should appear")
        
        // 3. Find and Tap a Movie Cell
        // Since we fetch remotely, we might need to wait a bit for cells to appear
        // We look for any button that starts with "movie_cell_"
        let movieCell = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'movie_cell_'")).firstMatch
        XCTAssertTrue(movieCell.waitForExistence(timeout: 10), "At least one movie cell should appear")
        movieCell.tap()
        
        // 4. Verify Detail Screen
        let likeButton = app.buttons["like_button"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Like button should appear on Detail Screen")
        
        // 5. Toggle Favorite
        likeButton.tap()
        
        // 6. Navigate Back
        // The back button usually has the title of the previous screen ("The Movie" is custom title in toolbar)
        // Or it is the first button in the navigation bar
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists {
             backButton.tap()
        }
        
        // 7. Verify back directly to List
        XCTAssertTrue(movieList.exists, "Should return to Movie List")
    }
}
