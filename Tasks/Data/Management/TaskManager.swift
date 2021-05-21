//
//  TaskManager.swift
//  Tasks
//
//  Created by Christophe Jeuland on 17/05/2021.
//

import Foundation

struct TaskManager {
    var taskList: [Task]
    let storage: CoreDataStorage = CoreDataStorage()
    
    init() {
        taskList  = storage.fetchTaskList()
    }
    
    @discardableResult
    mutating func addTask(withName taskName:String) -> Task {
        let newTask = Task(name: taskName)
        taskList.append(newTask)
        storage.addNewData(task: newTask)
        return newTask
    }
    
    mutating func toggleTaskStatus(withId taskId: UUID) {
        if let taskIndex = taskList.firstIndex(where: { (t) -> Bool in t.id == taskId }) {
            taskList[taskIndex].isDone.toggle()
            storage.updateTask(task: taskList[taskIndex])
        }
    }
}
