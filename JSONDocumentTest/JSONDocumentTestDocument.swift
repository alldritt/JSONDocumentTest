//
//  JSONDocumentTestDocument.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleJSON: UTType {
        UTType(exportedAs: "com.example.my-document-type")
    }
}

struct JSONDocumentTestDocument: FileDocument {
    let model: JSONDocumentTestModel // document model object

    init() {
        self.model = JSONDocumentTestModel() // default document contents
    }

    static var readableContentTypes: [UTType] { [.exampleJSON] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let model = try? JSONDecoder().decode(JSONDocumentTestModel.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.model = model
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(model)
        return .init(regularFileWithContents: data)
    }
}
