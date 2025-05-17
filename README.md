#GitHub Administrator#

An iOS application that allows browsing GitHub users and viewing their details.

🚀 After cloning the repository, open `GitHubHome.xcodeproj`
🎉🎉🎉🎉 Build and Run

##** Features **#

- Browse GitHub users with seamless, on-demand loading as you scroll
- View detailed user information
- Actor-based Disk Caching
- Image caching
- Composable Layouts / Diffable data sources
- SPM (Swift Package Manager)

##** Architecture Overview **##

🚀 The project follows the [MVVM pattern] combined with [Clean Architecture], adheres to SOLID principles, and leverages modern iOS practices, including:
 👉 Async/await for asynchronous operations (Swift Concurrency)
 👉 Networking Abstraction
 👉 Coordinator pattern for navigation flow
 👉 Combine for reactive programming
 👉 Protocol-oriented programming (POP)
 👉 Dependency Injection
 👉 Unit & Integration Testing

##** Requirements **##

- iOS 14.0+
- Xcode 16.2
- Swift 5.7+

##** Testing 🧪 **##

🚀 This project is split into multiple Swift packages **and** a top-level app target. Each has its own test suite.
👉 1. Open the workspace in Xcode.
👉 2. Select the scheme for the package or app you want to test:  
   🗂️ CoreKit, DomainKit, Infrastructure, Data, FeatureXYZ, etc.  
   🗂️ GitHubHome (top-level app/unit tests) or GitHubHomeUITests (UI tests) 
👉 3. Press `CMD + U` to run that package’s tests.  
👉 4. Use the Test navigator (`CMD + 6`) to run individual files or test classes.
