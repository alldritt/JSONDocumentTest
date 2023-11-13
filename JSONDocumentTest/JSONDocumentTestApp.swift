//
//  JSONDocumentTestApp.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//

import SwiftUI

@main
struct JSONDocumentTestApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: JSONDocumentTestDocument()) { file in
            ContentView(model: file.$document.model)
                .navigationTitle(FileManager.default.displayName(atPath: file.fileURL?.relativePath ?? ""))
        }
    }
}
