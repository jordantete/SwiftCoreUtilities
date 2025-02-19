#if SWIFTDATA_AVAILABLE
import SwiftData
import Foundation

public protocol SwiftDataManager {
    func save<T: PersistentModel>(_ object: T) throws
    func fetch<T: PersistentModel>(predicate: Predicate<T>?) throws -> [T]
    func delete<T: PersistentModel>(_ object: T) throws
    func deleteAll<T: PersistentModel>(ofType type: T.Type) throws
}

public final class SwiftDataManagerImpl: StorageManager {
    // MARK: - Private properties
    
    private let modelContainer: ModelContainer
    private let context: ModelContext
    
    // MARK: - Initialization
    
    public init(modelSchema: Schema, inMemory: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            self.modelContainer = try ModelContainer(for: modelSchema, configurations: config)
            self.context = ModelContext(modelContainer)
            LogManager.info("SwiftDataStorageManager initialized successfully.")
        } catch {
            fatalError("Failed to initialize SwiftDataStorageManager: \(error.localizedDescription)")
        }
    }
    
    // MARK: - SwiftDataManager
    
    public func save<T: PersistentModel>(_ object: T) throws {
        context.insert(object)
        try context.save()
        LogManager.info("Successfully saved \(T.self).")
    }
    
    public func fetch<T: PersistentModel>(predicate: Predicate<T>? = nil) throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try context.fetch(descriptor)
    }
    
    public func delete<T: PersistentModel>(_ object: T) throws {
        context.delete(object)
        try context.save()
        LogManager.info("Deleted \(T.self) successfully.")
    }
    
    public func deleteAll<T: PersistentModel>(ofType type: T.Type) throws {
        let objects = try fetch()
        for object in objects {
            context.delete(object)
        }
        try context.save()
        LogManager.info("Successfully deleted all \(T.self).")
    }
}
#endif
