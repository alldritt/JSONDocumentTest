//
//  JSONDocumentTestModel.swift
//  JSONDocumentTest
//
//  Created by Mark Alldritt on 2023-11-12.
//

import SwiftUI


@Observable class JSONDocumentTestModel: Codable {
    var textValue = ""
    var intValue = 100
    var boolValue = false

    /// Codable support
    ///
    /// Required for compatibility with @Observable - see https://callistaenterprise.se/blogg/teknik/2023/08/14/new-swift-observation/
    enum CodingKeys: String, CodingKey {
        case _textValue = "textValue"
        case _intValue = "intValue"
        case _boolValue = "boolValue"
    }

}


extension JSONDocumentTestModel {
    
    convenience init(model: JSONDocumentTestModel) {
        //  Create a "duplicate" of the model object to satisfy the needs of ReferenceFileDocument's snapshot(...)
        //  function which returns a "copy" of the document's model object.
        self.init()
        
        self.textValue = model.textValue
        self.intValue = model.intValue
        self.boolValue = model.boolValue
    }
    
}
