//
//  CDUtils.swift
//  ExtensionToolkit
//
//  Created by Trainee on 12/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import CoreData

public class CDUtils {
    
    public static func saveDataDictionary(_ dictionary: [[String: Any]], entity: String, context: NSManagedObjectContext, completionHandler: () -> Void) {
        for dict in dictionary as [[String: Any]] {
            CDUtils.saveDataObject(entityName: entity, dictionary: dict, parent: nil, context: context)
        }
        saveContext(context: context)
        completionHandler()
    }
    
    public static func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public static func download(_ url: URL, session: URLSession, completionHandler: @escaping(_ json: [String: Any]) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: url, completionHandler: { data, res, err in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else {
                print("nodata")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                completionHandler(json)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }).resume()
    }
    
    public static func saveDataObject(entityName: String, dictionary: [String: Any], parent: (entityName: String, value: NSManagedObject)?, context: NSManagedObjectContext) {
        let dataObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
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
                        saveDataObject(entityName: destinationName, dictionary: relationDictionary, parent: (entityName, dataObject), context: context)
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
