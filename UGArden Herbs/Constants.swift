//
//  Constants.swift
//  UGArden Herbs
//
//  Created by Jaco Van Rensburg on 2/12/19.
//  Copyright © 2019 NMI. All rights reserved.
//

import Foundation

struct AirtableURls {
    static let seedingURL = "https://api.airtable.com/v0/appKc1Zd3BiaCTlOs/Seed%20Data?api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    static let dryingURl = "https://api.airtable.com/v0/apptgk0JBqpaqbtT4/Drying%20Data?api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    static let teaURl = "https://api.airtable.com/v0/app0rj69BsqZwu9pS/Tea%20Data?api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    static let seedingBase = "https://api.airtable.com/v0/appKc1Zd3BiaCTlOs/Seed%20Data/"
    static let dryingBase = "https://api.airtable.com/v0/apptgk0JBqpaqbtT4/Drying%20Data/"
    static let teaBase = "https://api.airtable.com/v0/app0rj69BsqZwu9pS/Tea%20Data/"
    static let authentication = "api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    static let seedViewData = "https://api.airtable.com/v0/appKc1Zd3BiaCTlOs/Seed%20Data?api_key=keyhr7xMO6nFfKreF"
    static let dryingViewData = "https://api.airtable.com/v0/apptgk0JBqpaqbtT4/Drying%20Data?api_key=keyhr7xMO6nFfKreF&sort%5B0%5D%5Bfield%5D=Harvest+Date&sort%5B0%5D%5Bdirection%5D=desc"
    static let teaViewData = "https://api.airtable.com/v0/app0rj69BsqZwu9pS/Tea%20Data?api_key=keyhr7xMO6nFfKreF&sort%5B0%5D%5Bfield%5D=Date&sort%5B0%5D%5Bdirection%5D=desc"
}
