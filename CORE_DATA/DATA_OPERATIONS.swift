

import Foundation
import CoreData
class DATA_OPERATIONS: NSObject{
    var mainThreadContext: NSManagedObjectContext
    
    class var sharedDataOperation: DATA_OPERATIONS {
        struct Singleton {
            static let instance = DATA_OPERATIONS()
        }
        return Singleton.instance
    }
    
    override init(){
        self.mainThreadContext = COREDATA.sharedCoreData.mainThreadContext
    }
    
    // MARK: - DB Insert
    func insertNewObjectForEntityForName(entityName: String, context: NSManagedObjectContext? = nil) -> AnyObject {
        var moc = mainThreadContext
        if let manageObjcontext = context {
            //            if (context != nil) {
            moc = manageObjcontext
            //            }
        }
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc)
    }
    // MARK: - DB Save
    func saveMainThreadContext() {
        COREDATA.sharedCoreData.saveContext()
    }
    // MARK: - DB Fetch
    func fetchObjectForEntity(entityName: String, predicate: NSPredicate?, context: NSManagedObjectContext? = nil) -> AnyObject? {
        let returnArray = fetchAllObjectsForEntity(entityName, predicate: predicate, context: context)
        if let returnArray = returnArray where returnArray.count > 0 {
            return returnArray[0]
        } else {
            return nil
        }
    }
    func fetchAllObjectsForEntity(entityName: String, predicate: NSPredicate? = nil, context: NSManagedObjectContext? = nil) -> [AnyObject]? {
        var moc = mainThreadContext
        if let context = context {
            moc = context
        }
        var returnArray: [AnyObject]?
        objc_sync_enter(self)
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: moc)
        request.predicate = predicate
        do {
            returnArray = try mainThreadContext.executeFetchRequest(request)
        } catch let error as NSError {
            print(error)
            returnArray = nil
        } catch {
            print("Unknown error")
        }
        objc_sync_exit(self)
        return returnArray
    }
    // MARK: - DB Delete
    func deleteManagedObject(managedObject: NSManagedObject) {
        //        mainThreadContext.deleteObject(managedObject)
        //         do {
        //        if mainThreadContext.hasChanges {
        //            try mainThreadContext.save()
        //        }
        //         } catch let error as NSError {
        //                debugPrint(error)
        //            }
    }
    func deleteObjectsInEntity(entity: String, completion:(successful: Bool) -> Void) {
        let coord = COREDATA.sharedCoreData.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coord.executeRequest(deleteRequest, withContext: self.mainThreadContext)
            if self.mainThreadContext.hasChanges {
                self.mainThreadContext.performBlockAndWait { () -> Void in
                    do {
                        try self.mainThreadContext.save()
                        completion(successful: true)
                    } catch let error as NSError {
                        debugPrint(error)
                        completion(successful: false)
                    }
                }
            } else { completion(successful: true)}
        } catch let error as NSError {
            debugPrint(error)
            completion(successful: false)
        }
    }
}
