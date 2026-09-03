//
//  VoiceOverPractice.swift
//  AccessibilityImplementation
//
//  Created by Angela on 7/30/26.
//

import SwiftUI

struct VoiceOverPractice: View {
    @State private var isActive: Bool = false
    var body: some View {
        NavigationStack{
            
            Form{
                Section{
                    Toggle("Volume",isOn: $isActive)
                    
                    
                    HStack{
                        
                        Text("Volume")
                        Spacer()
                        Text("\(isActive ? "On" : "Off")")
                            .accessibilityHidden(true)
                    }
                    //.background(Color.red)
                    .opacity(isActive ? 1 : 0.3)
                    .onTapGesture {isActive.toggle()
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint(Text("Double tap to toggle setting"))
                    .accessibilityValue(isActive ? "is on" : "is off")
                    .accessibilityAction {
                        isActive.toggle()
                    }
                }header:{
                    Text("PREFERENCES")
                    
                }
                Section{
                    Button("Faves"){
                        
                        
                    }
                    Button{
                        
                        
                    }label:{
                        Image(systemName: "heart.fill")
                    }
                    .accessibilityLabel("Favorites")
                    
                    Text("Favorites")
                        .accessibilityAddTraits(.isButton)
                        .onTapGesture{
                            
                        }
                }header:{
                    Text("APPLICATION")
                   
                    
                }
                VStack{
                    Text("Content")
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                        .foregroundColor(.secondary)
                        .accessibilityAddTraits(.isHeader)
                    ScrollView(.horizontal,showsIndicators: false){
                        
                        
                        HStack(spacing: 8){
                            
                            ForEach(1..<10){
                                x in
                                VStack{
                                    
                                    Image("steve")
                                        .resizable().scaledToFit()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .cornerRadius(10)
                                    
                                    Text("ITEM \(x)")
                                }
                                .onTapGesture {
                                    
                                }
                                .accessibilityElement(children:.combine)
                                .accessibilityHint(Text("Double tap to swipe"))
                                .accessibilityAddTraits(.isButton)
                                .accessibilityLabel("Image \(x) out of 10. Image of album cover.")
                                .accessibilityAction {
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    VoiceOverPractice()
}
#Preview ("Spanish"){
    VoiceOverPractice()
        .environment(\.locale, Locale(identifier: "es"))
}
