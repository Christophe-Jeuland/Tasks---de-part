//
//  CoreDataStorage.swift
//  Tasks
//
//  Created by Christophe Jeuland on 17/05/2021.
//

import Foundation
import CoreData

class CoreDataStorage {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchTaskList() -> [Task] {
        let taskList: [Task]
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        if let rawTaskList = try? context.fetch(fetchRequest) {
            taskList = rawTaskList.compactMap({ (rawTask:CDTask) -> Task? in
                Task(fromCoreDataObject: rawTask)
            })
        } else {
            taskList = []
        }
        return taskList
    }
    
    func updateTask(task: Task) {
        if let existingTask =  fetchCDTask(withID: task.id) {
            existingTask.name = task.name
            existingTask.isDone = task.isDone
            saveData()
        }
    
        
    }
    
    private func fetchCDTask(withID taskId:UUID) -> CDTask? {
        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    
    func addNewData (task: Task) {
        let newTask = CDTask(context: context)
        newTask.id = task.id
        newTask.name = task.name
        newTask.isDone = task.isDone
        saveData()
    }
    
    private func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Erreur pendant la sauvegarde CoreData : \(error.localizedDescription)")
            }
        }
    }
}

extension Task {
    init? (fromCoreDataObject coreDatoObject: CDTask) {
        guard let id = coreDatoObject.id,
              let name = coreDatoObject.name  else {
            return nil
        }
        self.id = id
        self.name = name
        self.isDone = coreDatoObject.isDone
    }
}
