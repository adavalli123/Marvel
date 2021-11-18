import CoreData

class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Marvel")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
//        container.maxConcurrentOperationCount = 1
//        container.view
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    func applicationDocumentsDirectory() {
            if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                print(url.absoluteString)
            }
        }
    
    // MARK: - Save Core Data Context
    func saveContext() {
        let privateContext = persistentContainer.newBackgroundContext()
        privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        privateContext.automaticallyMergesChangesFromParent = true
//        guard privateContext.hasChanges else { return }
//        privateContext.parent = persistentContainer.viewContext
        
        privateContext.performAndWait {
            do {
                try privateContext.save()
                
                let viewContext = persistentContainer.viewContext
                guard viewContext.hasChanges else { return }
                viewContext.performAndWait {
                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            } catch let error {
                
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
//        privateContext.persistentStoreCoordinator = managedContext.persistentStoreCoordinator
//        privateContext.perform {
//            // Code in here is now running "in the background" and can safely
//            // do anything in privateContext.
//            // This is where you will create your entities and save them.
//        }
    }
}
