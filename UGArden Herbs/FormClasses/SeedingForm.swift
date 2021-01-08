
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
    var postUrl: String = AirtableURLs.seedingURL

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seeding Form"
        configureForm()
    }
}

