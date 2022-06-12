//
//  ViewController.swift
//  Codes_VersionKit
//
//  Created by 山本響 on 2022/06/12.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    
    /// Check if isSupported and isAvailable
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startScanningPressed(_ sender: Any) {
        guard scannerAvailable == true else {
            print("❌ Error: Scanner is not available for usage. Please check settings.")
            return
        }
        
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.text(), .barcode()], isHighlightingEnabled: true)
        dataScanner.delegate = self
        present(dataScanner, animated: true)
        try? dataScanner.startScanning()
        
    }
    
}

extension ViewController: DataScannerViewControllerDelegate {
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            print("text: \(text.transcript)")
            UIPasteboard.general.string = text.transcript
        case .barcode(let code):
            guard let urlString = code.payloadStringValue else { return }
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        default:
            print("❌ Unexpected item.")
        }
    }
}

