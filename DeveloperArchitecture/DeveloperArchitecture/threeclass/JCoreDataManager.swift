//
//  JCoreDataManager.swift
//  DeveloperArchitecture
//
//  Created by Jeffrey on 2020/9/26.
//

import Foundation
import UIKit
import CoreData

public class JCoreDataManager: NSObject {
    //单例
    static let shared = JCoreDataManager()

    lazy var documentDir : URL = {
        let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return documentDir!
    }()

    // 拿到AppDelegate中创建好了的NSManagedObjectContext
    lazy var managedObjectModel : NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "DatasaseModel", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        return managedObjectModel!
    }()
    
    lazy var persistentStoreCoordinator : NSPersistentStoreCoordinator = { //懒加载持久化存储协调器
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel)
        let sqliteURL = documentDir.appendingPathComponent("DatasaseModel.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true]
        var failureReason  = "创建NSPersistentStoreCoordinator时出现错误"
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch  {
            var dict = [String : Any]()
            dict[NSLocalizedDescriptionKey] = "初始化NSPersistentStoreCoordinator失败"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error

            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            abort()
        }
        return persistentStoreCoordinator
    }()
    
    lazy var context : NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    

    private func funj_saveMessageContext() {
        do{
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func funj_insertMessageContext(_ dict : Dictionary<String,String>,mainDic : Dictionary<String,String>?) {
        if mainDic != nil {
            var sql = ""
            for (key,value) in mainDic! {
                sql += "\(key) == \(value)"
            }
            let fetchRequest : NSFetchRequest = NSManagedObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: sql)
            do {
                var dataModel = try context.fetch(fetchRequest).first
                if dataModel == nil {
                    let thisType = String(describing: type(of: self))
                    dataModel = NSEntityDescription.insertNewObject(forEntityName: thisType, into: context)
                }
                for (key,value) in dict {
                    (dataModel as AnyObject).setValue(value, forKey: key)
                }
            } catch  {
                fatalError()
            }
        }else {
            let thisType = String(describing: type(of: self))
            let dataModel = NSEntityDescription.insertNewObject(forEntityName: thisType, into: context)
            for (key,value) in dict {
                dataModel.setValue(value, forKey: key)
            }
        }
        funj_saveMessageContext()
    }
    func funj_getMessageContext(_ fetchRequest : NSFetchRequest<NSFetchRequestResult> ,_ dict : Dictionary<String,String>)  ->[Any] {
        return funj_getMessageContext(fetchRequest , dict: dict, asc: nil, desc: nil, limit: nil)
    }
    func funj_getMessageContext(_ fetchRequest : NSFetchRequest<NSFetchRequestResult> , dict : Dictionary<String,String>,asc : String?,desc : String?,limit:String?) ->[Any] {
        var sql = ""
        for (key,v) in dict {
            let value = v as NSString

            if value.hasPrefix("<=") {
                sql +=  key + " <= " + value.substring(from: 2) + ","
            }else if value.hasPrefix(">=") {
                sql +=  key + " >= " + value.substring(from: 2) + ","
            }else if value.hasPrefix("=") {
                sql +=  key + " = " + value.substring(from: 1) + ","
            }else if value.hasPrefix(">") {
                sql +=  key + " > " + value.substring(from: 1) + ","
            }else if value.hasPrefix("<") {
                sql +=  key + " < " + value.substring(from: 2) + ","
            }else if value.hasPrefix("!=") {
                sql +=  key + " != " + value.substring(from: 2) + ","
            }else if value.hasPrefix(">=") {
                sql +=  key + ">=" + value.substring(from: 2) + ","
            }else if value.hasPrefix("like") {
                sql +=  key + "like '%" + value.substring(from: 2) + "%',"
            }
        }
        
        if sql.count > 0 {
            sql.removeLast()
            
            if asc != nil {
                sql += " order by \(asc!) asc"
            }else if desc != nil {
                sql += " order by \(desc!) desc"
            }
            if limit != nil {
                sql += " limit \(limit!)"
            }
            
            fetchRequest.predicate = NSPredicate(format: sql)
        }

        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch  {
            fatalError()
        }
    }
    
    func funj_deleteMessageContext(_ fetchRequest:NSFetchRequest<NSFetchRequestResult>,dict : Dictionary<String,String>){
        var sql = ""
        for (key,value) in dict {
            sql += "\(key) == \(value)"
        }

        fetchRequest.predicate = NSPredicate(format: sql)

        do {
            let result = try context.fetch(fetchRequest)
            for dataModel in result {
                context.delete(dataModel as! NSManagedObject)
            }
        } catch  {
            fatalError()
        }
        funj_saveMessageContext()
    }
}

