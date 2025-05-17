import XCTest

final class GitHubHomeUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testUserListLoading() throws {
        let collection = app.collectionViews.firstMatch
        XCTAssertTrue(collection.exists)
        
        // Wait for cells to load
        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testUserDetailNavigation() throws {
        let collection = app.collectionViews.firstMatch
        
        // Wait for cells to load
        let cell = collection.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
        // Tap first cell
        cell.tap()
        
        // Verify navigation to detail screen
        let detailNavBar = app.navigationBars["User Details"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 1))
        
        // Method 1: Wait for specific UI elements that indicate loading is complete
        let detailProfileImage = app.images.element(boundBy: 0) // Avatar image
        XCTAssertTrue(detailProfileImage.waitForExistence(timeout: 3))
    }
}
