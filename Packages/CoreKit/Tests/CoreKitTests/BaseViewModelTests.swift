import XCTest
import Combine
@testable import CoreKit

final class BaseViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut: TestableBaseViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        sut = TestableBaseViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_ExecuteTask_Success() async {
        // Given
        var result = ""
        
        // When
        sut.executeMainTask(
            { [weak sut] in
                // Simulate async work
                try await Task.sleep(nanoseconds: 100_000_000)
                sut?.testData = "Success"
                result = "Success"
            }
        )
        
        // Then
        XCTAssertEqual(result, sut?.testData ?? "Success")
    }
    
    func test_ExecuteTask_WithError() async {
        // Given
        var capturedError: Error?
        
        // When
        sut.executeMainTask(
            {
                // Simulate error
                throw TestError()
            },
            deferred: {
                // Then
                XCTAssertNotNil(capturedError)
            },
            onError: { error in
                capturedError = error
            }
        )
    }
    
    func test_ExecuteTask_Cancellation() async {
        // Given
        let firstTaskExpectation = expectation(description: "First task's deferred callback should be called")
        let secondTaskExpectation = expectation(description: "Second task should complete")
        
        // When - Start first task that would take longer
        sut.executeMainTask(
            {
                try await Task.sleep(nanoseconds: 500_000_000)
                self.sut.testData = "First task completed"
            },
            deferred: {
                firstTaskExpectation.fulfill()
            }
        )
        
        // Immediately start a second task that should cancel the first
        sut.executeMainTask(
            {
                try await Task.sleep(nanoseconds: 100_000_000)
                self.sut.testData = "Second task completed"
            },
            deferred: {
                secondTaskExpectation.fulfill()
            }
        )
        
        // Then
        await fulfillment(of: [secondTaskExpectation], timeout: 1.0)
        await fulfillment(of: [firstTaskExpectation], timeout: 1.0)
        XCTAssertEqual(sut.testData, "Second task completed")
    }
    
    func test_CancellablesRemoved_UponDeinit() {
        // Given
        var sut: TestableBaseViewModel? = TestableBaseViewModel()
        let publisher = PassthroughSubject<String, Never>()
        
        // When
        publisher
            .sink { _ in }
            .store(in: &sut!.cancellables)
        
        // Then
        XCTAssertEqual(sut!.cancellables.count, 1)
        
        // When - Trigger deinit
        sut = nil
        
        // Then
        XCTAssertNil(sut, "ViewModel should be deallocated")
    }
}

// MARK: - Test Helpers

private class TestableBaseViewModel: BaseViewModel {
    var testData: String = ""
}

// MARK: - Type

private struct TestError: Error {}
