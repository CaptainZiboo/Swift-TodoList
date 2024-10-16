//
//  ContentView.swift
//  TodoList
//
//  Created by POYART Lucas on 15/10/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var blabla: AuthViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.red)
            .padding()
        }
        .background(.background)
    }
}

#Preview {
    ContentView()
}
