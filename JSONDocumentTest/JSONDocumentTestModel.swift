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
