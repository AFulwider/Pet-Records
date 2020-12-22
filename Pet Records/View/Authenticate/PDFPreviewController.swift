//
//  PDFPreviewController.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 12/21/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewController: UIViewController {

    let pdfView = PDFView()
    
    var vaccine = [Vaccine]()
    var medication = [Medication]()
    var pet : Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PDF Viewer"
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.backgroundColor = .white
        let data = PDFMaker.shared.createRecord(pet: pet!,vaccine: vaccine, medication: medication)
        pdfView.document = PDFDocument(data: data)
    }
}
