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

final class JSONDocumentTestDocument: ReferenceFileDocument {
    typealias Snapshot = JSONDocumentTestModel

    let model: JSONDocumentTestModel // document model object

    static var readableContentTypes: [UTType] { [.exampleJSON] }

    init() {
        self.model = JSONDocumentTestModel() // default document contents
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let model = try? JSONDecoder().decode(JSONDocumentTestModel.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.model = model
    }
    
    func snapshot(contentType: UTType) throws -> Snapshot {
        //  Looking at the headers for ReferenceFileDocument.snapshot(...), Apple shows code which duplicates
        //  the model object, but defers serializing the object to the ReferenceFileDocument.fileWrapper(...)
        //  call.
        //
        //  Note that this call blocks the UI and so should be as quick as possible.
        return JSONDocumentTestModel(model: model) // make a copy of the model object
    }
    
    func fileWrapper(snapshot: Snapshot, configuration: WriteConfiguration) throws -> FileWrapper {
        //  The headers for ReferenceFileDocument.fileWrapper(...) indicate this call takes place on a
        //  background thread and must not interact with the UI, or presumably the model.
        let data = try JSONEncoder().encode(snapshot)
        return .init(regularFileWithContents: data)
    }

}
