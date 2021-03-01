//
//  Seedable.swift
//  UGArden Herbs
//
//  Created by Jacobus Janse van Rensburg on 10/27/20.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation
import Eureka
import SuggestionRow

protocol Seedable { }
extension Seedable where Self: FormViewController & FormUtils {
    func configureForm() {
        form +++ Section("Seeding Form")
        <<< SuggestionAccessoryRow<String>("Plant Name") {
            $0.title = "Crop Name"
            $0.filterFunction = { text in
                PlantNames.shared.names.filter({ $0.hasPrefix(text) })
            }
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnChange
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        <<< DateRow("Date Started") {
            $0.title = "Date Started (Seed or Cutting)"
            $0.value = Date()
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnChange
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
            if !row.isValid {
                cell.backgroundColor = .red
            }
        }
        <<< IntRow("Total # of Seeds") {
            $0.title = "Number of seeds planted/cuttings"
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        <<< DateRow("Date of Germination") {
            $0.title = "Date of First Germination"
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        <<< IntRow("Total Number Germinated") {
            $0.title = "Total Number Germinated"
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        <<< TextAreaRow("Notes") {
            $0.title = "Notes"
            $0.placeholder = "Notes for any seed treatment"
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        <<< DateRow("Date Planted") {
            $0.title = "Date Planted"
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        form +++ Section("Submit")
        <<< ButtonRow("Submit") {
            $0.title = "Submit"
            $0.onCellSelection(self.buttonTapped)
        }.cellUpdate { cell, row in
            cell.height = { return 70 }
        }
        <<< ButtonRow("Clear") { row in
            row.onCellSelection(self.buttonTapped)
        }.cellUpdate { cell, row in
            cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
            cell.height = { return 70 }
        }
    }
}
