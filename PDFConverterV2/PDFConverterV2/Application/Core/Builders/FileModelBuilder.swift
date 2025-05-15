
import Foundation

final class FileModelBuilder {
    private var fileURL: URL?
    private var fileName: String?

    func setFileURL(_ url: URL) -> FileModelBuilder {
        self.fileURL = url
        return self
    }

    func setFileName(_ name: String) -> FileModelBuilder {
        self.fileName = name
        return self
    }

    func build() throws -> FileModel {
        guard let url = fileURL else {
            throw BuilderError.missingFileURL
        }
        guard let name = fileName else {
            throw BuilderError.missingFileName
        }
        return FileModel(fileURL: url, fileName: name)
    }

    enum BuilderError: Error, LocalizedError {
        case missingFileURL
        case missingFileName

        var errorDescription: String? {
            switch self {
            case .missingFileURL:
                return "File URL is required."
            case .missingFileName:
                return "File name is required."
            }
        }
    }
}
