
import QuickLook

class PDFPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
    
    init(data: Data) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp.pdf")
        do {
            try data.write(to: tempURL)
            previewItemURL = tempURL
            previewItemTitle = "Preview"
        } catch {
            print("Error creating temp file: \(error)")
        }
    }
}
