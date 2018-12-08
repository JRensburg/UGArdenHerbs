//
//  TeaForm.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/20/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Eureka
import Alamofire

class TeaForm: FormViewController, FormUtils {
    var postUrl = "https://api.airtable.com/v0/app0rj69BsqZwu9pS/Tea%20Data?api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 60/255, green: 80/255, blue: 11/255, alpha: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleToFill
        self.navigationItem.title = "Tea Form"
        //self.navigationItem.titleView
        configureForm()
    }
    
    func configureForm(){
        form +++ Section("Tea Production")
            <<< DateRow("Date"){
                $0.title = "Date"
                $0.value = Date()
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Tea Blend"){
                $0.title = "Tea Blend"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Batch Number"){
                $0.title = "Batch Number"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Lot Number"){
                $0.title = "Lot Number"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Post!"
                $0.onCellSelection(self.buttonTapped)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< ButtonRow("Clear"){ row in
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
        }
    }
    
}
