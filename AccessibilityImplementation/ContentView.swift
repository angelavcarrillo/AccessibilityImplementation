//
//  ContentView.swift
//  AccessibilityImplementation
//
//  Created by Angela on 7/30/26.
//

import SwiftUI

struct ContentView: View {
    @State private var task = ["Buy groceries", "Call mom"]
@State private var newTask: String = ""
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    
                    TextField("Enter a new task",text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityValue(newTask)
                    
                    Button("add"){
                        if !newTask.isEmpty{
                            task.append(newTask)
                            UIAccessibility.post(notification: .announcement, argument: "Task added \(newTask)")
                            newTask = ""
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .accessibilityLabel(Text("Add new Task"))
                }
                .padding()
                
                List{
                    ForEach(task, id:\.self){
                    
                    task in
                        Text(task)
                            .font(.body)
                            .accessibilityHint(Text("Swipe left to delete"))
                }
                    .onDelete{
                        indexSet in
                        task.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle(Text("My Tasks"))
            
        }
    }
}

#Preview {
    ContentView()
}
