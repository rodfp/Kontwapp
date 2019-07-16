//
//  CounterDataHandler.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/15/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CounterDataHandler{
  
  static var entityName = "Counter"
  
  static func getAllCounters(callback: @escaping ([Counter]) -> Void){
    NetworkService.getAllCounters { (counterData, error) in
      DispatchQueue.main.async {
        guard let counterData = counterData else {
          callback([])
          return
        }
        CounterDataHandler.updateCounterData(counterData)
        let counters = CounterDataHandler.getAllDeviceStoredCounters()
        callback(counters)
      }
    }
  }
  
  static func createCounter(title : String, callback: @escaping (Bool) -> Void){
    NetworkService.createCounter(title: title) { (counterData, error) in
      DispatchQueue.main.async {
        guard let counterData = counterData else {
          callback(false)
          return
        }
        CounterDataHandler.updateCounterData(counterData)
        callback(true)
      }
    }
  }
  
  static func deleteCounter(counter : Counter, callback: @escaping (Bool) -> Void){
    guard let counterId = counter.id else {
      callback(false)
      return
    }
    NetworkService.deleteCounter(counterId: counterId) { (counterData, error) in
      DispatchQueue.main.async {
        guard let counterData = counterData else {
          callback(false)
          return
        }
        CounterDataHandler.updateCounterData(counterData)
        CounterDataHandler.deleteCounter(counter)
        callback(true)
      }
    }
  }
  
  static func increaseCounter(counter : Counter, callback: @escaping (Bool) -> Void){
    guard let counterId = counter.id else {
      callback(false)
      return
    }
    NetworkService.increaseCounter(counterId: counterId) { (counterData, error) in
      DispatchQueue.main.async {
        guard let counterData = counterData else {
          callback(false)
          return
        }
        CounterDataHandler.updateCounterData(counterData)
        callback(true)
      }
    }
  }
  
  static func decreaseCounter(counter : Counter, callback: @escaping (Bool) -> Void){
    guard let counterId = counter.id else {
      callback(false)
      return
    }
    NetworkService.decreaseCounter(counterId: counterId) { (counterData, error) in
     DispatchQueue.main.async {
        guard let counterData = counterData else {
          callback(false)
          return
        }
        CounterDataHandler.updateCounterData(counterData)
        callback(true)
      }
    }
  }
  
  fileprivate static func updateCounterData(_ counterData : [CounterNetworkData]){
    for counter in counterData{
      CounterDataHandler.modifyOrCreateCounter(id: counter.id, title: counter.title, count: counter.count)
    }
  }
  
}

extension CounterDataHandler{
  
  static func getAllDeviceStoredCounters() -> [Counter] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    let sort = NSSortDescriptor(key: #keyPath(Counter.dateCreated), ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    var results: [NSManagedObject] = []
    do {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
      let context = appDelegate.persistentContainer.viewContext
      results = try context.fetch(fetchRequest)
    }
    catch {
      return []
    }
    guard let counters = results as? [Counter] else { return [] }
    return counters
  }
  
  fileprivate static func getCounter(_ counterId : String) -> Counter?{
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    fetchRequest.predicate = NSPredicate(format: "id = %@", counterId)
    var results: [NSManagedObject] = []
    do {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
      let context = appDelegate.persistentContainer.viewContext
      results = try context.fetch(fetchRequest)
    }
    catch {
      return nil
    }
    return results.first as? Counter
  }

  fileprivate static func modifyOrCreateCounter(id: String?, title : String?, count: Int){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    guard let entityCounter = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
    guard let counterId = id else { return }
    if let counter = getCounter(counterId){
      counter.count = Int16(count)
    }else{
      guard let newCounter = NSManagedObject(entity: entityCounter, insertInto: context) as? Counter else { return }
      newCounter.id = id
      newCounter.title = title
      newCounter.count = Int16(count)
      newCounter.dateCreated = Date()
    }
    saveContext(context)
  }
  
  fileprivate static func saveCounter(_ counter : Counter){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    guard let counterId = counter.id else { return }
    if let existingCounter = getCounter(counterId) {
      existingCounter.id = counter.id
      existingCounter.title = counter.title
      existingCounter.count = counter.count
    } else{
      guard let entityCounter = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
      guard let newCounter = NSManagedObject(entity: entityCounter, insertInto: context) as? Counter else { return }
      newCounter.id = counter.id
      newCounter.title = counter.title
      newCounter.count = counter.count
      newCounter.dateCreated = counter.dateCreated ?? Date()
    }
    saveContext(context)
  }
  
  fileprivate static func deleteCounter(_ counter : Counter){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    context.delete(counter)
    saveContext(context)
  }
  
  fileprivate static func deleteAllCounters(completion: @escaping (Bool?, String?) -> ()){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityName))
    do {
      try context.execute(deleteRequest)
    }
    catch {
      completion(false, error.localizedDescription)
      print(error)
    }
    completion(true, nil)
  }
  
  fileprivate static func saveContext(_ context : NSManagedObjectContext){
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
  
}
