
import Foundation

final class FileSystemManager {
    static let shared = FileSystemManager()
    private init() {}
    
    func getSelectedFileURL(pdfData: Data, fileName: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error writing PDF to file: \(error)")
            return nil
        }
    }
}
