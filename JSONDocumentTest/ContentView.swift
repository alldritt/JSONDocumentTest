//
//  ContentView.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//

import SwiftUI


struct ContentView: View {
    //  When working with 
    @Environment(\.undoManager) var undoManager
    @State var model: JSONDocumentTestModel
    
    var body: some View {
        Form {
            HStack {
                Text("Text")
                UndoProvider($model.textValue, actionName: "Change Text") { textValue in
                    TextField("text", text: textValue)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity)
                }
            }
            HStack {
                UndoProvider($model.intValue) { intValue in
                    Stepper("Int Value", value: intValue)
                    Text("\(intValue.wrappedValue)")
                }
            }
            HStack {
                UndoProvider($model.boolValue, actionName: "Change Bool Value") { boolValue in
                    Toggle("Bool Value", isOn: boolValue)
                }
            }
        }
        .modifier(UndoRedoToolbarButtonsViewModifier())
        .modifier(UndoRedoGesturesViewModifier())
    }
}

#Preview {
    ContentView(model: JSONDocumentTestModel())
}
