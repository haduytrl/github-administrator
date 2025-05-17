import Foundation
import Combine

open class BaseViewModel {
    // MARK: - Properties
    
    public var cancellables = Set<AnyCancellable>()
    private var mainTask: Task<Void, Never>?
    
    // MARK: - Initial
    
    public init() {}
    
    // MARK: - Methods
    /// Executes an async throwing closure safely on a background task.
    ///
    /// - Parameters:
    ///   - task: The async throwing work to perform.
    ///   - deferred: A closure to run on the main thread **after** the task completes or errors.
    ///   - onError: A closure to run on the main thread if `task` throws, with the error’s message.
    public func executeMainTask(
        _ task: @escaping () async throws -> Void,
        deferred: (() -> Void)? = nil,
        onError: ((Error) async -> Void)? = nil
    ) {
        // Cancel any previous task
        mainTask?.cancel()
        
        // Launch a new Task
        mainTask = Task {
            defer {
                if let deferred { deferred() }
            }
            
            do {
                try await task()
            } catch {
                // Report other errors
                await onError?(error)
            }
        }
    }
    
    /// Optional: cancel the current mainTask early
    open func reset() {
        mainTask?.cancel()
        mainTask = nil
    }
}
