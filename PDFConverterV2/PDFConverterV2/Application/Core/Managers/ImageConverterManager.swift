
import UIKit
import PDFKit
import WebKit

final class ImageConverterManager: StorageItem {
    
    func convertImageToPDF(images: [UIImage]) -> Data? {
        let pdfDocument = PDFDocument()
        for image in images {
            guard let pdfPage = PDFPage(image: image) else { continue }
            pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
        }
        return pdfDocument.dataRepresentation()
    }
    
    func convertImageFromWebView(webView: WKWebView) -> Data {
        let printPageRenderer = UIPrintPageRenderer()
        let printFormatter = webView.viewPrintFormatter()
        
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let printableRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let paperRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        
        printPageRenderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for pageIndex in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: pageIndex, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        let convertedPDFData = pdfData as Data
        return convertedPDFData
    }
}
