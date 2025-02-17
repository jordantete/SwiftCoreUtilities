import Foundation
import BackgroundTasks

protocol BackgroundSyncService {
    func startSyncing()
    func stopSyncing()
    var syncInterval: TimeInterval { get set }
}

final class BackgroundSyncServiceImpl: BackgroundSyncService {
    // MARK: - Private properties
    
    private let dataService: DataService
    private let persistenceService: PersistenceService
    private let syncTaskManager: SyncTaskManager
    var syncInterval: TimeInterval = 1260 // Default to 21 minutes
    
    // MARK: - Initialization
    
    init(
        dataService: DataService,
        persistenceService: PersistenceService,
        syncTaskManager: SyncTaskManager
    ) {
        self.dataService = dataService
        self.persistenceService = persistenceService
        self.syncTaskManager = syncTaskManager
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.lapile.syncData", using: nil) { [weak self] task in
            self?.handleBackgroundSync(task: task as? BGAppRefreshTask)
        }
    }
    
    // MARK: - Public methods
    
    func startSyncing() {
        scheduleNextSync()
        LogManager.info("BackgroundSyncService scheduled with interval: \(syncInterval) seconds")
    }
    
    func stopSyncing() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.lapile.syncData")
        LogManager.info("BackgroundSyncService stopped")
    }
    
    // MARK: - Private methods
    
    private func scheduleNextSync() {
        let request = BGAppRefreshTaskRequest(identifier: "com.lapile.syncData")
        request.earliestBeginDate = Date(timeIntervalSinceNow: syncInterval) // Next sync
        
        do {
            try BGTaskScheduler.shared.submit(request)
            LogManager.info("Next background sync scheduled")
        } catch {
            LogManager.error("Failed to schedule background sync: \(error.localizedDescription)")
        }
    }
    
    private func handleBackgroundSync(task: BGAppRefreshTask?) {
        LogManager.info("Executing background sync task")

        Task {
            defer { task?.setTaskCompleted(success: true) }
            await dataService.syncPendingData()
        }
    }
}

