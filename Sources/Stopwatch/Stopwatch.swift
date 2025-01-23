import Foundation
import Darwin

public final class Stopwatch {
    // MARK: - Constants
    private static let ticksPerMillisecond: Int64 = 10_000
    private static let ticksPerSecond: Int64 = ticksPerMillisecond * 1_000

    public static let Frequency: Int64 = {
        var info = mach_timebase_info_data_t()
        mach_timebase_info(&info)

        let rawFreq = Double(NSEC_PER_SEC) * Double(info.denom) / Double(info.numer)
        return Int64(rawFreq)
    }()

    public static let IsHighResolution: Bool = true

    private static let tickFrequency: Double = {
        return Double(Stopwatch.ticksPerSecond) / Double(Stopwatch.Frequency)
    }()

    // MARK: - Fields
    private var _elapsed: Int64 = 0
    private var _startTimestamp: Int64 = 0
    private var _isRunning = false

    // MARK: - Initializers
    public init() {
        reset()
    }

    // MARK: - Public Functions
    public func start() {
        if !isRunning {
            _startTimestamp = Self.getTimestamp()
            _isRunning = true
        }
    }

    public static func startNew() -> Stopwatch {
        let watch = Stopwatch()
        watch.start()
        return watch
    }

    public func stop() {
        if _isRunning {
            let endTimestamp = Self.getTimestamp()
            let elapsedThisPeriod = endTimestamp &- _startTimestamp
            _elapsed &+= elapsedThisPeriod
            _isRunning = false

            _elapsed = _elapsed < 0 ? 0 : _elapsed
        }
    }

    public func reset() {
        _elapsed = 0
        _isRunning = false
        _startTimestamp = 0
    }

    public func restart() {
        _elapsed = 0
        _startTimestamp = Self.getTimestamp()
        _isRunning = true
    }

    // MARK: - Properties
    public var isRunning: Bool { _isRunning }

    public var elapsed: TimeInterval {
        let dateTimeTicks = getElapsedDateTimeTicks()
        return Double(dateTimeTicks) / Double(Self.ticksPerSecond)
    }

    public var elapsedMilliseconds: Int64 { getElapsedDateTimeTicks() / Self.ticksPerMillisecond }

    public var elapsedTicks: Int64 { getRawElapsedTicks() }

    public var description: String {
        "\(elapsed) sec"
    }

    // MARK: - Static Functions
    public static func getTimestamp() -> Int64 {
        Int64(mach_absolute_time())
    }

    public static func getElapsedTime(_ startingTimestamp: Int64) -> TimeInterval {
        getElapsedTime(startingTimestamp, endingTimestamp: getTimestamp())
    }

    public static func getElapsedTime(_ startingTimestamp: Int64, endingTimestamp: Int64) -> TimeInterval {
        let rawDelta = endingTimestamp &- startingTimestamp
        let dateTimeTicks = Int64(Double(rawDelta) * Self.tickFrequency)
        return Double(dateTimeTicks) / Double(Self.ticksPerSecond)
    }

    // MARK: - Internel Functions
    private func getRawElapsedTicks() -> Int64 {
        var timeElapsed = _elapsed
        if _isRunning {
            let currentTimeStamp = Self.getTimestamp()
            let elapsedUntilNow = currentTimeStamp &- _startTimestamp
            timeElapsed &+= elapsedUntilNow
        }
        return timeElapsed
    }

    private func getElapsedDateTimeTicks() -> Int64 {
        let raw = getRawElapsedTicks()
        return Int64(Double(raw) * Self.tickFrequency)
    }
    // MARK: -
}

extension Stopwatch: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Stopwatch (Elapsed=\(elapsed)s, IsRunning=\(isRunning))"
    }
}
