//
//  UndoProvider.swift
//  UndoProvider
//
//  A View wrapper that makes changes to a binding undoable.
//
//  Adapted from Matthaus Woolard's UndoProvider
//  https://github.com/NilCoalescing/SwiftUI-Code-Examples/blob/main/Undo-and-Redo/Shared/UndoProvider.swift
//

import SwiftUI

class UndoHandler<Value: Equatable>: ObservableObject {
    //  Note that instances of this object are handed to the undoManager as the target for
    //  undo/redo operations.  The UndoManager does NOT retain these instances so they must
    //  be retained elsewhere.  @StateObject (see below) does this for us.
    
    fileprivate var binding: Binding<Value>?
    fileprivate weak var undoManger: UndoManager?
    
    fileprivate func registerUndo(from oldValue: Value, to newValue: Value, actionName: String? = nil) {
        if oldValue != newValue {
            undoManger?.registerUndo(withTarget: self) { handler in
                handler.registerUndo(from: newValue, to: oldValue, actionName: actionName)
                handler.binding?.wrappedValue = oldValue
            }
            if let actionName {
                undoManger?.setActionName(actionName)
            }
        }
    }
    
    fileprivate init() {}
}


struct UndoProvider<WrappedView, Value>: View where WrappedView: View, Value: Equatable {
    //
    //  Usage:
    //
    //  struct ContentView: View {
    //      ...
    //      @Binding var boolValue: Bool // a binding to some model value
    //
    //      var body: some View {
    //          ...
    //          UndoProvider($boolValue) { boolValue in
    //              Toggle("Bool Value", isOn boolValue
    //          }
    //          ...
    //      }
    //  }
    
    @Environment(\.undoManager) var undoManager
    
    @StateObject var handler: UndoHandler<Value> = UndoHandler()
    
    private let wrappedView: (Binding<Value>) -> WrappedView
    private let binding: Binding<Value>
    private let actionName: String?
    
    init(_ binding: Binding<Value>, actionName: String? = nil, @ViewBuilder wrappedView: @escaping (Binding<Value>) -> WrappedView) {
        self.binding = binding
        self.wrappedView = wrappedView
        self.actionName = actionName
    }
    
    private var interceptedBinding: Binding<Value> {
        Binding {
            self.binding.wrappedValue
        } set: { newValue in
            if self.binding.wrappedValue != newValue {
                self.handler.registerUndo(from: self.binding.wrappedValue, to: newValue, actionName: actionName)
                self.binding.wrappedValue = newValue
            }
        }
    }
    
    var body: some View {
        wrappedView(self.interceptedBinding)
            .onAppear {
                self.handler.binding = self.binding
                self.handler.undoManger = self.undoManager
            }
            .onChange(of: self.undoManager) {
                self.handler.undoManger = self.undoManager
            }
    }
}


#Preview {
    UndoProvider(.constant(1)) { binding in
        Text("Hello")
    }
}
