//
//  DetailsAttestationViewController.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit
import PDFKit

class DetailsAttestationViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    let presenter: DetailsAttestationPresenter = DetailsAttesationPresenterImpl()
    
    var delegate: MainViewDelegate?
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = fileName?
            .components(separatedBy: "/")
            .last?
            .replacingOccurrences(of: ".pdf", with: "") ?? ""
        presenter.attach(view: self)
        if let fileName = fileName,
            let pdfDocument = PDFDocument(url: URL(fileURLWithPath: fileName)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
        }
    }
    
    func setDelegate(delegate: MainViewDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func didTapOnDeleteButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete this attestation?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Delete forever",
                          style: .destructive,
                          handler: { (action) -> Void in
                            self.presenter.deleteFile(filePath: self.fileName)
                          }
            )
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (a) -> Void in }))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension DetailsAttestationViewController: DetailsAttestationView {
    func onFileDeleted() {
        delegate?.didDeleteAttestation()
        navigationController?.popViewController(animated: true)
    }
}
