//
//  ContentView.swift
//  Tasks
//
//  Created by Maxime Britto on 22/07/2020.
//

import SwiftUI

extension AnyTransition {

}

struct TaskListView: View {
    @State var newTaskName:String = ""
    @State var taskManager = TaskManager()
    @State var addNewTask = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut){
                    addNewTask.toggle()
                }
            }, label: {
                VStack {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .transition(.scale(scale: 2))
                        .rotationEffect(.degrees(addNewTask ? 45 : 0))
                        .scaleEffect(addNewTask ? 2 : 1)
                    if addNewTask {
                        HStack {
                            TextField("Nouvelle tâche", text: $newTaskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: createNewTask, label: {
                                Image(systemName: "plus")
                            }).disabled(newTaskName.count == 0)
                        }.padding()
                    }
                }
            })
            
            VStack(alignment: HorizontalAlignment.leading ) {
                ForEach(taskManager.taskList) { task in
                    TaskCell(task: task)
                        .onTapGesture {
                            userTappedTask(task)
                        }
                }
            }
            Spacer()
        }
    }
    
    func createNewTask() {
        if newTaskName.count > 0 {
            taskManager.addTask(withName: newTaskName)
            newTaskName = ""
        }
    }
    
    func userTappedTask(_ task:Task) {
        taskManager.toggleTaskStatus(withId: task.id)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
