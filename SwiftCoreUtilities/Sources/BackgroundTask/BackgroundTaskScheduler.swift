import BackgroundTasks

public protocol BackgroundTaskScheduler {
    func registerTask(withIdentifier identifier: String, handler: @escaping (BGTask) -> Void)
    func scheduleTask(identifier: String, interval: TimeInterval)
    func cancelTask(withIdentifier identifier: String)
    func isTaskScheduled(identifier: String) -> Bool
}

public final class BackgroundTaskSchedulerImpl: BackgroundTaskScheduler {
    // MARK: - Private properties

    private var scheduledTasks: Set<String> = []
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - BackgroundTaskScheduler
    
    public func registerTask(withIdentifier identifier: String, handler: @escaping (BGTask) -> Void) {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil, launchHandler: handler)
    }
    
    public func scheduleTask(identifier: String, interval: TimeInterval) {
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: interval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            scheduledTasks.insert(identifier)
            LogManager.info("Scheduled background task: \(identifier)")
        } catch {
            LogManager.error("Failed to schedule background task: \(error.localizedDescription)")
        }
    }
    
    public func cancelTask(withIdentifier identifier: String) {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier)
        scheduledTasks.remove(identifier)
        LogManager.info("Cancelled background task: \(identifier)")
    }
    
    public func isTaskScheduled(identifier: String) -> Bool {
        scheduledTasks.contains(identifier)
    }
}
