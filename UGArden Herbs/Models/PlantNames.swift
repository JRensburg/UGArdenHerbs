//
//  PlantNames.swift
//  UGArden Herbs
//
//  Created by Jacobus Janse van Rensubrg on 2/28/21.
//  Copyright © 2021 NMI. All rights reserved.
//

import Foundation
import Alamofire

class PlantNames {
    public static let shared = PlantNames()
    
    private(set) var names: [String] = []
    let defaults = UserDefaults.standard
    let defaultKey = "plantNames"
    init() {
        names = defaults.stringArray(forKey: defaultKey) ?? []
    }
    
    func refresh() {
//        let url = URL(string: AirtableURLs.plantNames)!
//        let request = URLRequest(url: url)
        AF.request(AirtableURLs.plantNames).responseJSON {[weak self] in
            guard let self = self else {return}
            let records = (($0.value as? [String:Any]) ?? [:])["records"]
            let plantNames = (records as? [[String:Any]])?.reduce([]) {base, value -> [String] in
                if let fields = (value["fields"] as? [String:String]) {
                    var baseCopy = base
                    baseCopy.append(fields["Plant Names"]!)
                    return baseCopy
                } else {return base}
            }
            if plantNames != nil {
                self.names = plantNames!
                self.defaults.setValue(plantNames!, forKey: self.defaultKey)
            }
        }
            //value in (value["fields"] as? [String:String])["Plant Names"]
    }
}
