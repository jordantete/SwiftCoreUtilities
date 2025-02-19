actor SyncTaskManager {
    private var isSyncing = false
    
    func startSync() async -> Bool {
        guard !isSyncing else {
            LogManager.warning("Sync already in progress. Skipping new sync.")
            return false
        }
        isSyncing = true
        LogManager.info("Sync started")
        return true
    }

    func endSync() {
        LogManager.info("Sync completed.")
        isSyncing = false
    }
}
