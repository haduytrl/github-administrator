import XCTest
import UIKit
@testable import CoreKit

final class CoordinatorTests: XCTestCase {
    
    // MARK: - Properties
    
    private var parentCoordinator: MockCoordinator!
    private var childCoordinator: MockCoordinator!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        parentCoordinator = MockCoordinator()
        childCoordinator = MockCoordinator()
        
        // Set up parent-child relationship
        childCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator.childCoordinators.append(childCoordinator)
    }
    
    override func tearDown() {
        parentCoordinator = nil
        childCoordinator = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_ChildCoordinator_IsAddedToParent() {
        // Given
        let newChildCoordinator = MockCoordinator()
        
        // When
        parentCoordinator.childCoordinators.append(newChildCoordinator)
        
        // Then
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 2)
        XCTAssertTrue(parentCoordinator.childCoordinators.contains(where: { $0 === newChildCoordinator }))
    }
    
    func test_ChildCoordinator_IsRemovedWhenFinished() {
        // Given
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 1)
        XCTAssertTrue(parentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
        
        // When
        childCoordinator.finish()
        
        // Then
        XCTAssertEqual(parentCoordinator.childCoordinators.count, 0)
        XCTAssertFalse(parentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
    }
    
    func test_StartMethodIsCalled() {
        // Given
        let mockCoordinator = MockCoordinator()
        XCTAssertFalse(mockCoordinator.startCalled)
        
        // When
        mockCoordinator.start()
        
        // Then
        XCTAssertTrue(mockCoordinator.startCalled)
    }
}

// MARK: - Mock Implementation

private class MockCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var startCalled = false
    
    func start() {
        startCalled = true
    }
} 
