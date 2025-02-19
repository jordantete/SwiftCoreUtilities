import Foundation
import BackgroundTasks

public protocol BackgroundSyncService {
    func startSyncing()
    func stopSyncing()
    var syncInterval: TimeInterval { get set }
    func setTask(_ task: @escaping () -> Void)
}

public final class BackgroundSyncServiceImpl: BackgroundSyncService {
    // MARK: - Properties
    
    private let scheduler: BackgroundTaskScheduler
    private let taskIdentifier = "com.task.identifier"
    public var syncInterval: TimeInterval = 1260 // Default: 21 minutes
    private var backgroundTask: (() -> Void)?
    
    // MARK: - Initialization
    
    public init(scheduler: BackgroundTaskScheduler = BackgroundTaskSchedulerImpl()) {
        self.scheduler = scheduler
    }
    
    // MARK: - Public methods
    
    public func startSyncing() {
        guard backgroundTask != nil else {
            LogManager.warning("No task registered. Call setTask() before starting sync.")
            return
        }

        scheduler.registerTask(withIdentifier: taskIdentifier) { [weak self] task in
            self?.executeBackgroundTask(task: task as? BGAppRefreshTask)
        }

        scheduleNextSync()
        LogManager.info("Background sync started (Interval: \(syncInterval) seconds)")
    }
    
    public func stopSyncing() {
        scheduler.cancelTask(withIdentifier: taskIdentifier)
        LogManager.info("Background sync stopped")
    }

    public func setTask(_ task: @escaping () -> Void) {
        self.backgroundTask = task
        LogManager.info("Background task set successfully")
    }
    
    // MARK: - Private methods
    
    private func scheduleNextSync() {
        scheduler.scheduleTask(identifier: taskIdentifier, interval: syncInterval)
        LogManager.info("Next background sync scheduled in \(syncInterval) seconds")
    }
    
    private func executeBackgroundTask(task: BGAppRefreshTask?) {
        LogManager.info("Executing background task")

        Task {
            defer { task?.setTaskCompleted(success: true) }

            guard let taskToRun = backgroundTask else {
                LogManager.warning("No task set, skipping execution")
                return
            }
            
            taskToRun()
            LogManager.info("Background task execution completed")
            scheduleNextSync()
        }
    }
}

