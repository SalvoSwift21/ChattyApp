//
//  PDFDocuments+Extensions.swift
//  GoogleAIFeature
//
//  Created by Salvatore Milazzo on 10/12/24.
//

import PDFKit
import GoogleGenerativeAI

extension PDFDocument: @retroactive ThrowingPartsRepresentable {
    public func tryPartsValue() throws -> [ModelContent.Part] {
        guard let preferredMIMEType = self.documentURL?.mimeType()?.preferredMIMEType else { return [] }
        guard let data = self.dataRepresentation() else { return [] }
        return [.data(mimetype: preferredMIMEType, data)]
    }
}
