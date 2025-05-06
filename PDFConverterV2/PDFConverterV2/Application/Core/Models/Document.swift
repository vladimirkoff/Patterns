//
//  Document.swift
//  PDFConverterV2

import Foundation

struct Document: Hashable {
    let name: String
    let date: Date
    let pdf: Data
    let imageCoverData: Data
    let id: String
    
    static func `default`() -> Document {
        Document(name: .empty,
                      date: Date(),
                      pdf: Data(),
                      imageCoverData: Data(),
                      id: .empty)
    }
}
