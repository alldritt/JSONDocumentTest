//
//  UndoRedoToolbarButtonsViewModifier.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//

import SwiftUI


struct UndoRedoToolbarButtonsViewModifier: ViewModifier {
    @Environment(\.undoManager) var undoManager
    @State var update = false
    
    //  undoManager is not observable so we have to listen for notifiations in order to update
    //  the Undo and Redo buttons correctly.  The answer to this SO question pointed me in the
    //  currect direction: https://stackoverflow.com/questions/60647857/undomanagers-canundo-property-not-updating-in-swiftui
    //
    
    private let newUndoGroupObserver = NotificationCenter.default.publisher(for: .NSUndoManagerDidCloseUndoGroup)
    private let didUndoObserver = NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange)
    private let didRedoObserver = NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange)

    func body(content: Content) -> some View {
        let _ = update // cause the view to update
        
        content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Undo", systemImage: "arrow.uturn.backward") {
                        undoManager?.undo()
                    }
                    .labelsHidden()
                    .disabled(!(undoManager?.canUndo ?? false))
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Redo", systemImage: "arrow.uturn.forward") {
                        undoManager?.redo()
                    }
                    .labelsHidden()
                    .disabled(!(undoManager?.canRedo ?? false))
                }
            }
            .onReceive(newUndoGroupObserver) { _ in
                //  An undoable action has been registered.
                update.toggle()
            }
            .onReceive(didUndoObserver) { _ in
                //  The user has undone something
                update.toggle()
            }
            .onReceive(didRedoObserver) { _ in
                //  The user has redone something
                update.toggle()
            }
    }
}
