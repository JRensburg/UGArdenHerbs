 
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

class SeedingForm: FormViewController, FormUtils, Seedable {
    var postUrl: String = AirtableURls.seedingURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seeding Form"
        configureForm()
    }
    
    func configureForm(){
        configureSeedForm()

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

