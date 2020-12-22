//
//  mapsViewController.swift
//  Pet Records
//
//  Created by Monideepa Sengupta on 12/12/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit
import PDFKit
import Firebase

class PDFMaker {
    static let shared = PDFMaker()
    
    func createRecord(pet:Pet, vaccine:[Vaccine], medication:[Medication]) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let pageWidth = 8.5 * 72.0 // 612
        let pageHeight = 11 * 72.0 // 792
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            // FONT SIZES
            let font_size_Small = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let font_size_Medium = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
            let font_size_Large = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50)]
            // BORDER::
            drawRect(start: CGPoint(x:0, y:0), end: CGPoint(x: 612, y: 0), width: 4) // top left 2 top right
            drawRect(start: CGPoint(x:0, y:0), end: CGPoint(x: 0, y: 792), width: 4) // top left to bottom left
            drawRect(start: CGPoint(x:612, y:792), end: CGPoint(x: 612, y: 0), width: 4) // bottom right to top right
            drawRect(start: CGPoint(x:612, y:792), end: CGPoint(x: 0, y: 792), width: 4) // bottom right to bototm left
            let title = "Vet Record"
            title.draw(at: CGPoint(x: 10, y: 0), withAttributes: font_size_Large)
            // Hor Lines
            drawRect(start: CGPoint(x:4, y:55), end: CGPoint(x: 612, y: 55), width: 4)
            let ownerPDF = "Owner"
            ownerPDF.draw(at: CGPoint(x: 10, y: 60), withAttributes: font_size_Medium)
            /*************************************************************************/
            let ownerNameHeader = "Name: Aaron Fulwider"
            ownerNameHeader.draw(at: CGPoint(x: 10, y: 102), withAttributes: font_size_Small)
            let phoneNumberHeader = "Phone Number: (918)856-7940"
            phoneNumberHeader.draw(at: CGPoint(x: 10, y: 132), withAttributes: font_size_Small)
            let addressHeader = "Address: 9978 Kika CT. San Diego, CA. 92129"
            addressHeader.draw(at: CGPoint(x: 10, y: 162), withAttributes: font_size_Small)
            let dateHeader = "Date: 12/22/2020"
            dateHeader.draw(at: CGPoint(x: 315, y: 102), withAttributes: font_size_Small)
            // Hor LINES
            drawRect(start: CGPoint(x:4, y:95), end: CGPoint(x: 612, y: 95), width: 2)
            drawRect(start: CGPoint(x:4, y:125), end: CGPoint(x: 612, y: 125), width: 2)
            drawRect(start: CGPoint(x:4, y:155), end: CGPoint(x: 612, y: 155), width: 2)
            drawRect(start: CGPoint(x:4, y:185), end: CGPoint(x: 612, y: 185), width: 2)
            // VERT LINES
            drawRect(start: CGPoint(x:311, y:95), end: CGPoint(x: 311, y: 125), width: 2)
            /*************************************************************************/
            let petHeader = "Pet"
            petHeader.draw(at: CGPoint(x: 10, y: 190), withAttributes: font_size_Medium)
            let nameOfPetHeader = "Name: \(pet.name!)"
            nameOfPetHeader.draw(at: CGPoint(x: 10, y: 232), withAttributes: font_size_Small)
            let petBirthDateHeader = "Birth Date: \(pet.dob!)"
            petBirthDateHeader.draw(at: CGPoint(x: 10, y: 262), withAttributes: font_size_Small)
            let breedOfPetHeader = "Breed: \(pet.breed!)"
            breedOfPetHeader.draw(at: CGPoint(x: 315, y: 232), withAttributes: font_size_Small)
            let genderOfPetHeader = "Gender: \(pet.gender!)"
            genderOfPetHeader.draw(at: CGPoint(x: 315, y: 262), withAttributes: font_size_Small)
            // HOR LINES
            drawRect(start: CGPoint(x:4, y:225), end: CGPoint(x: 612, y: 225), width: 2)
            drawRect(start: CGPoint(x:4, y:255), end: CGPoint(x: 612, y: 255), width: 2)
            drawRect(start: CGPoint(x:4, y:285), end: CGPoint(x: 612, y: 285), width: 2)
            // VERT LINES
            drawRect(start: CGPoint(x:311, y:225), end: CGPoint(x: 311, y: 285), width: 2)
            /*************************************************************************/
            let vaccineHeader = "Vaccinations"
            vaccineHeader.draw(at: CGPoint(x: 10, y: 295), withAttributes: font_size_Medium)
            // HOR LINES
            drawRect(start: CGPoint(x:4, y:330), end: CGPoint(x: 612, y: 330), width: 2)
            var point = CGPoint(x: 4, y: 335)
            for i in vaccine {
                let string = "\(i.title ?? "N/A(title)") - \(i.vacDate ?? "N/A(vacDate)")"
                string.draw(at: point, withAttributes: font_size_Small)
                point = CGPoint(x: point.x, y: point.y + 25)
            }
            var point2 = CGPoint(x: 4, y: 540)
            for i in medication {
                let string = "\(i.title ?? "N/A(title)") - \(i.descriptionString ?? "N/A(description)")"
                string.draw(at: point2, withAttributes: font_size_Small)
                point2 = CGPoint(x: point2.x, y: point2.y + 25)
            }
            drawRect(start: CGPoint(x:4, y: 490), end: CGPoint(x: 612, y: 490), width: 2)
            /*************************************************************************/
            let medicationHeader = "Medication"
            medicationHeader.draw(at: CGPoint(x: 10, y: 500), withAttributes: font_size_Medium)
            // HOR LINES
            drawRect(start: CGPoint(x:4, y:535), end: CGPoint(x: 612, y: 535), width: 2)
        }
        return data
    }
    
    func drawRect(start:CGPoint, end:CGPoint, width:CGFloat) {
        let aPath = UIBezierPath()
        aPath.move(to: start)
        aPath.addLine(to: end)
        aPath.close()
        UIColor.black.set()
        aPath.lineWidth = width
        aPath.stroke()
    }
}
