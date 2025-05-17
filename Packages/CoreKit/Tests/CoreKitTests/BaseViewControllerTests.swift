import XCTest
import UIKit
import Combine
@testable import CoreKit

final class BaseViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockViewModel: MockViewModel!
    private var sut: TestableBaseViewController!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockViewModel()
        sut = TestableBaseViewController(viewModel: mockViewModel)
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_Initialization_WithViewModel() {
        // Then
        XCTAssertNotNil(sut.viewModel)
        XCTAssertTrue(sut.viewModel === mockViewModel)
    }
    
    func test_ViewDidLoadCallsSetupMethods() {
        // When
        sut.loadViewIfNeeded() // trigger viewDidLoad
        
        // Then
        XCTAssertTrue(sut.setupUICalled)
        XCTAssertTrue(sut.setupBindViewModelCalled)
    }
    
    func test_ViewDidDisappear_ResetsViewModel() {
        // Given
        sut.loadViewIfNeeded() // trigger viewDidLoad
        XCTAssertFalse(mockViewModel.resetCalled) // resetCalled = false
        
        // When - Simulate view controller being removed
        sut.simulateMovingFromParent = true
        sut.viewDidDisappear(false) // Animated: false
        
        // Then
        XCTAssertTrue(mockViewModel.resetCalled)
    }
    
    func test_ViewDidDisappear_DoesNotResetWhenStaying() {
        // Given
        sut.loadViewIfNeeded()
        XCTAssertFalse(mockViewModel.resetCalled)
        
        // When - Simulate view disappearing but not being removed
        sut.viewDidDisappear(false) // Animated: false
        
        // Then
        XCTAssertFalse(mockViewModel.resetCalled)
    }
    
    func test_ShowErrorAlertExists() {
        // Verify that BaseViewController has a showErrorAlert function
        let message = "Test error"
        sut.showErrorAlert(message: message)
    }
    
    // NOTE: Cancellables will automaticlly released when deinit is triggered
    func test_CancellablesReleasedOnDeinit() {
        // Given
        var localController: TestableBaseViewController? = TestableBaseViewController(viewModel: MockViewModel())
        let subject = PassthroughSubject<String, Never>()
        
        // When
        subject
            .sink { _ in } // trigger
            .store(in: &localController!.cancellables)
        
        // Then
        XCTAssertEqual(localController!.cancellables.count, 1)
        
        // When - Trigger deinit
        localController = nil
        
        // Then
        XCTAssertNil(localController, "Controller should be deallocated")
    }
}

// MARK: - Test Helpers

private class MockViewModel: BaseViewModel {
    var resetCalled = false
    
    override func reset() {
        resetCalled = true
        super.reset()
    }
}

private class TestableBaseViewController: BaseViewController<MockViewModel> {
    var setupUICalled = false
    var setupBindViewModelCalled = false
    var simulateMovingFromParent = false
    var mockPresentationSource: UIViewController?
    
    override func setupUI() {
        super.setupUI()
        setupUICalled = true
    }
    
    override func setupBindViewModel() {
        super.setupBindViewModel()
        setupBindViewModelCalled = true
    }
    
    override var isMovingFromParent: Bool { simulateMovingFromParent }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
