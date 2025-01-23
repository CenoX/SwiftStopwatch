# SwiftStopwatch

A Swift-based high-resolution timing utility, inspired by the .NET Stopwatch class. It uses macOS/iOS APIs (mach_absolute_time()) to provide performance measurements similar to what Stopwatch offers in the .NET framework.

## Overview

In .NET, `Stopwatch` measures elapsed time using a high-resolution performance counter (QueryPerformanceCounter on Windows).
This Swift counterpart uses mach_absolute_time() and related APIs on Apple platforms, making it suitable for precise measurements of time intervals in Swift applications.

* High resolution: Uses Apple’s `mach_absolute_time()`.
* Easy to use: Similar API to .NET’s `Stopwatch` (e.g. `start()`, `stop()`, `reset()`, `restart()`).
* Accurate timing: Convert raw ticks to .NET-like "ticks" (100 nanoseconds) for consistency with the original class.

## Installation

You can add `SwiftStopwatch` as a dependency in your Swift Package Manager–based project:
1. In Xcode, open File → Add Packages....
2. Enter the repository URL `https://github.com/CenoX/SwiftStopwatch.git)` and follow the prompts.
3. Add `SwiftStopwatch` as a dependency to your target.

Alternatively, in your Package.swift:
```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/CenoX/SwiftStopwatch.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: ["SwiftStopwatch"]),
    ]
)
```

## Usage

```swift
import SwiftStopwatch

func doSomeWork() {
    let sw = Stopwatch.startNew()
    // ... Perform your tasks ...
    sw.stop()

    print("Elapsed seconds: \(sw.elapsed)")
    print("Elapsed ms: \(sw.elapsedMilliseconds)")
}
```

### API
`start()`: Starts the timer (no effect if already running).
`stop()`: Stops the timer (no effect if already stopped).
`reset()`: Resets the accumulated time to zero and stops.
`restart()`: Resets the timer to zero and starts immediately.
`isRunning`: Indicates whether the stopwatch is currently running.
`elapsed`: Returns the elapsed time in seconds (as a TimeInterval).
`elapsedMilliseconds`: Returns the elapsed time in milliseconds.
`elapsedTicks`: Returns the raw ticks (based on `mach_absolute_time()`), analogous to the raw counter in .NET.

## Inspiration: .NET Stopwatch

This library is inspired by the .NET Stopwatch class. The .NET Stopwatch measures elapsed time based on a high-resolution performance counter. Here’s an excerpt of the original C# code’s description:
"This class uses a high-resolution performance counter if the installed hardware supports it. Otherwise, the class will fall back to DateTime and uses ticks as a measurement."
We mirrored the API to maintain consistency, but we replaced QueryPerformanceCounter() with mach_absolute_time() for Apple platforms.

## License

MIT License. See [LICENSE](license.md) for details.
