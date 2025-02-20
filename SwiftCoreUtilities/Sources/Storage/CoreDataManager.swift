import CoreData

public protocol CoreDataManager {
    var context: NSManagedObjectContext { get }
    func save<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) throws
    func fetchData<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [T]
    func delete<T: NSManagedObject>(_ object: T)
    func deleteAll<T: NSManagedObject>(entity: T.Type)
}

public final class CoreDataManagerImpl: CoreDataManager {
    // MARK: - Public properties
    
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Initialization
    
    init() {
        guard let modelURL = Bundle(for: CoreDataManagerImpl.self).url(forResource: "DataModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }
        
        self.persistentContainer = NSPersistentContainer(name: "DataModel", managedObjectModel: model)
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                LogManager.error("Failed to load Core Data stack: \(error)")
            } else {
                LogManager.info("Core Data stack loaded successfully")
            }
        }
    }
    
    // MARK: - CoreDataManager
    
    public var context: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    public func save<T: NSManagedObject>(_ entity: T.Type, configure: (T) -> Void) throws {
        let context = self.context

        try context.performAndWait {
            let object = T(context: context)
            configure(object)

            do {
                try context.save()
                LogManager.info("Successfully saved \(entity) with ID: \(object.objectID)")
            } catch {
                LogManager.error("Failed to save \(entity): \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    public func fetchData<T: NSManagedObject>(
        entity: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        let context = self.context

        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        return try context.performAndWait {
            do {
                let results = try context.fetch(fetchRequest)
                LogManager.info("Successfully fetched \(results.count) items for entity: \(entityName)")
                return results
            } catch {
                let predicateDescription = predicate?.predicateFormat ?? "None"
                let errorMessage = "CoreData fetch failed for \(entityName). Predicate: \(predicateDescription). Error: \(error.localizedDescription)"
                LogManager.error(errorMessage)
                throw error
            }
        }
    }
    
    public func delete<T: NSManagedObject>(_ object: T) {
        let context = self.context
        
        context.performAndWait {
            guard !object.isDeleted else {
                LogManager.warning("Attempted to delete an already deleted \(T.self) object: \(object.objectID)")
                return
            }
            
            if context.registeredObjects.contains(object) {
                context.delete(object)
                do {
                    try context.save()
                    LogManager.info("Successfully deleted \(T.self) - ID: \(object.objectID)")
                } catch {
                    LogManager.error("Failed to delete \(T.self) - ID: \(object.objectID) - Error: \(error.localizedDescription)")
                }
            } else {
                LogManager.warning("Object \(T.self) is not registered in the current context. Skipping deletion.")
            }
        }
    }
    
    public func deleteAll<T: NSManagedObject>(entity: T.Type) {
        let context = self.context
        
        context.performAndWait {
            let entityName = String(describing: entity)
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            
            do {
                let count = try context.count(for: fetchRequest)
                if count == 0 {
                    LogManager.info("No records found for \(entityName). Nothing to delete.")
                    return
                }
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                let deletedObjectIDs = result?.result as? [NSManagedObjectID] ?? []

                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedObjectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])

                try context.save()
                context.refreshAllObjects()
                LogManager.info("Successfully deleted \(count) records of \(entityName)")
            } catch {
                LogManager.error("Failed to delete all \(entityName) records: \(error.localizedDescription)")
            }
        }
    }
}
