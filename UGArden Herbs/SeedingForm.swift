 
//
//  SeedingForm.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/20/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Eureka
import SuggestionRow
import Alamofire

 class SeedingForm: FormViewController, FormUtils {
    var postUrl: String = AirtableURls.seedingURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seeding Form"
        configureForm()
    }
    
    func configureForm(){
        
        form +++ Section("Seeding Form")
            <<< SuggestionAccessoryRow<String>("Plant Name"){
                $0.title = "Crop Name"
                $0.filterFunction = { text in
                options.filter({$0.hasPrefix(text)})
                }
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Started"){
                $0.title = "Date Started (Seed or Cutting)"
                $0.value = Date()
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< IntRow("Total # of Seeds"){
                $0.title = "Number of seeds planted/cuttings"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date of Germination"){
                $0.title = "Date of First Germination"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< IntRow("Total Number Germinated"){
                $0.title = "Total Number Germinated"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< TextAreaRow("Notes"){
                $0.title = "Notes"
                $0.placeholder = "Notes for any seed treatment"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Planted"){
                $0.title = "Date Planted"
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
            }
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Submit"
                $0.onCellSelection(self.buttonTapped)
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< ButtonRow("Clear"){ row in
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
                     cell.height = {return 70}
                }
    
    }
}
