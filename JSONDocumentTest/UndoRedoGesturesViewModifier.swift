//
//  UndoRedoGesturesViewModifier.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//
//  Code detecting the state of the UIAccessibility.isShakeToUndoEnabled came from Thomas
//  Durand's blog: https://blog.thomasdurand.fr/story/2023-09-04-shake-to-undo-swiftui/
//

import SwiftUI


struct UndoRedoGesturesViewModifier: ViewModifier {
    @Environment(\.undoManager) var undoManager
    @State private var showConfirmation = false

    //  NOTE: Three-finger-tap undo/redo gesture is handled by the system.
    
    func body(content: Content) -> some View {
        content
            .onShake {
                //  Handle shake-to-undo/redo gesture
                if let undoManager,
                    !showConfirmation && UIAccessibility.isShakeToUndoEnabled && (undoManager.canUndo || undoManager.canRedo) {
                    showConfirmation.toggle()
                }
            }
            .actionSheet(isPresented: $showConfirmation, content: {
                var buttons = [ActionSheet.Button]()
                
                //  Build the list of buttons for the sheet based on the state of the undoManager
                if let undoManager {
                    if undoManager.canUndo {
                        let title = undoManager.undoActionName.isEmpty ? "Undo" : "Undo \(undoManager.undoActionName)"

                        buttons.append(.default(Text(title)) {
                            undoManager.undo()
                        })
                    }
                    if undoManager.canRedo {
                        let title = undoManager.redoActionName.isEmpty ? "Redo" : "Redo \(undoManager.redoActionName)"
                        
                        buttons.append(.default(Text(title)) {
                            undoManager.redo()
                        })
                    }
                }
                buttons.append(.cancel())
                
                return ActionSheet(title: Text("Undo/Redo"),
                                   buttons: buttons)
            })
    }

}
