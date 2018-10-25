//
//  ViewData.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 10/24/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import RxCocoa
import RxSwift
import RxAlamofire

class ViewData: UIViewController {

    private let tableView = UITableView()
    private let cellIdentifier = "cellIdentifier"
    private let label = UILabel()
    
    private let disposeBag = DisposeBag()
    private let apiClient = APIClient()
    var data : Observable<[dryingData]>?
    //let viewModel : dryingModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        let ugh: Observable<[dryingModel]> = self.apiClient.send(apiRequest: DryingRequest()).debug()
        ugh.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
            cell.textLabel?.text = model.data.cropName
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureProperties(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    private func configureLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}

protocol APIRequest {
    var method: HTTPMethod {get}
    var path: String { get }
    //var parameters: [String : String] { get }
}

extension APIRequest {
    func request() -> URLRequest {
 
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = method.rawValue
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class DryingRequest : APIRequest {
    var method = HTTPMethod.get
    var path = "https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8"
    
}

struct dryingModel: Codable{
    let id: String
    let createdTime: String
    let data: dryingData
    private enum CodingKeys : String, CodingKey {
        case id
        case createdTime
        case data
    }
}

struct dryingData : Codable {
    
    let cropName: String
    let dateHarvested: String
    let plotNrow: String
    let feetHarvested: Int
    let plantPart: String
    let harvestWeight: Int
    let dryingCondition: String
    let temp: Int
    let humidity: Int
    let dateDried: String
    let dryWeight: Int
    let processedWeight: Int
    let lotNumber: String
    
//    init(dict: [String:Any]){
//        self.cropName = dict["Crop"] as? String ?? ""
//        self.dateHarvested = dict["Harvest Date"] as? String ?? ""
//        self.plotNrow = dict["Plot and Row"] as? String ?? ""
//        self.feetHarvested = dict["Feet Harvested"] as? Int ?? 0
//        self.plantPart = dict["Plant Part"] as? String ?? ""
//        self.harvestWeight = dict["Harvest Weight"] as? Int ?? 0
//        self.dryingCondition = dict["Drying Condition"] as? String ?? ""
//        self.temp = dict["Temprature"] as? Int ?? 0
//        self.humidity = dict["Relative Humidity"] as? Int ?? 0
//        self.dateDried = dict["Date Dried"] as? String ?? ""
//        self.dryWeight = dict["Dry Weight"] as? Int ?? 0
//        self.processedWeight = dict["Processed Weight"] as? Int ?? 0
//        self.lotNumber = dict["Lot Number"] as? String ?? ""
//    }
    
    private enum CodingKeys: String, CodingKey {
        case cropName
        case dateHarvested
        case plotNrow
        case feetHarvested
        case plantPart
        case harvestWeight
        case dryingCondition
        case temp
        case humidity
        case dateDried
        case dryWeight
        case processedWeight
        case lotNumber
    }
}

class APIClient {

    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
            return Observable<T>.create { observer in
                let request = URLRequest(url: URL(string: "https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8")!)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
    }
}
//            let request = apiRequest.request()
//                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                    if let error = error {
//                        observer.onError(error)
//                    }
//                    else{
//                        observer.onNext(data!)
//                        observer.onCompleted()
//                    }
//                }
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//                }
//            }
//
//        func objects<T: JSONDecodable>(resource: Resource) -> Observable<[T]> {
//            return data(resource).map { data in
//                guard let objects: [T] = decode(data) else {
//                    throw APIClientError.CouldNotDecodeJSON
//                }
//
//                return objects
//            }
//        }
//        let theThing = RxAlamofire.requestJSON(.get,"https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8").debug()
//            .map({ (request) -> [String: Any] in
//                if let dict = request.1 as? [String: Any] {
//                return dict
//                } else { return ["":""]}
//
//            }).flatMap({ (dict) -> Observable<(String, String, dryingData)> in
//                let id = dict["id"] as! String
//                let createdTime = dict["createdTime"] as! String
//                let model = dryingData(dict: dict["fields"] as! [String:Any])
//                observer.onNext((id,createdTime,dryingData))
//                observer.onCompleted()
//            })
//            .subscribe(onNext: { [weak self] (r, json) in
//              if let dict = json as? [String: Any] {
//                return dict
//                }
//            })
//    let id = dict["id"] as! String
//    let createdTime = dict["createdTime"] as! String
//    let model = dryingData(dict: dict["fields"] as! [String:Any])
//    

//typealias JSONDictionary = [String: AnyObject]
//
//protocol JSONDecodable {
//    init?(dictionary: JSONDictionary)
//}
//
//func decode<T: JSONDecodable>(dictionaries: [JSONDictionary]) -> [T] {
//    return dictionaries.compactMap { T(dictionary: $0) }
//}
//
//func decode<T: JSONDecodable>(dictionary: JSONDictionary) -> T? {
//    return T(dictionary: dictionary)
//}
//
//func decode<T:JSONDecodable>(data: Data) -> [T]? {
//    guard let JSONObject = try? JSONSerialization.jsonObject(with: data, options: []),
//        let dictionaries = JSONObject as? [JSONDictionary],
//        let objects: [T] = decode(dictionaries: dictionaries) else {
//            return nil
//    }
//
//    return objects
//}

//class DryingViewModel: JSONDecodable {
//
//    let id: String
//    let createdTime: String
//    var data: dryingData
//
//    required init?(dictionary: JSONDictionary) {
//        guard let id = dictionary["id"] as? String,
//            let createdTime = dictionary["createdTime"] as? String else {
//                return nil
//        }
//
//        self.id = id
//        self.createdTime = createdTime
//        self.data = dryingData(dict: (dictionary["borders"] as? [String: Any])!)
//
//    }
//
//    private let apiClient = APIClient()
//
//    init(){
//        info = apiClient.send().debug()
//    }
//}
