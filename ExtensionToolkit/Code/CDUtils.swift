//
//  CDUtils.swift
//  ExtensionToolkit
//
//  Created by Trainee on 12/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import CoreData

public class CDUtils {
    
    public static var managedContext: NSManagedObjectContext!
    
    public static func fetch<T:NSManagedObject>(resultType: T.Type, filter: NSPredicate? = nil) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = filter
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return nil
        }
    }
    
    public static func saveDataDictionary(_ dictionary: [[String: Any]], entity: String, completionHandler: () -> Void) {
        for dict in dictionary as [[String: Any]] {
            CDUtils.saveDataObject(entityName: entity, dictionary: dict, parent: nil)
        }
        saveContext()
        completionHandler()
    }
    
    public static func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            print("No changes to save")
        }
    }
    
    public static func saveDataObject(entityName: String, dictionary: [String: Any], parent: (entityName: String, value: NSManagedObject)?) {
        let dataObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)
        
        if let parent = parent {
            dataObject.setValue(parent.value, forKey: parent.entityName)
        }
        
        for kvp in dictionary {
            if let property = dataObject.entity.propertiesByName[kvp.key] {
                if let relationDescription = property as? NSRelationshipDescription, let values = kvp.value as? [[String: Any]] {
                    guard let destinationName = relationDescription.destinationEntity?.name else {
                        continue
                    }
                    for relationDictionary in values {
                        saveDataObject(entityName: destinationName, dictionary: relationDictionary, parent: (entityName, dataObject))
                    }
                } else if let attributeDescription = property as? NSAttributeDescription {
                    if attributeDescription.attributeType == .dateAttributeType, let dateString = kvp.value as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: dateString)
                        
                        dataObject.setValue(date, forKey: kvp.key)
                    } else {
                        if kvp.value is NSNull {
                            dataObject.setValue(nil, forKey: kvp.key)
                        } else {
                            dataObject.setValue(kvp.value, forKey: kvp.key)
                        }
                    }
                } else {
                    print("Unknown property: \(kvp.key)")
                }
            }
        }
    }
}
