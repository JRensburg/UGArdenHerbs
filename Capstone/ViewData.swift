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
    private let label = UILabel()
    
    let segmentContainer = UIView()
    let tabs = UIView()
    private let disposeBag = DisposeBag()
    private let apiClient = APIClient<dryingModel>()
    var data : Observable<[dryingData]>?
    //let viewModel : dryingModel
    @IBOutlet var SegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        
        self.apiClient.pull(url: "https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8").debug().bind(to: tableView.rx.items(cellIdentifier: "dryingCell")){ index, model, cell in
            cell.textLabel?.text = model.fields.cropName ?? "No name entered"
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureProperties(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dryingCell")
    }
    private func configureLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.layer.zPosition = 10
        tabs.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        //segmentContainer.backgroundColor(
        
        
        view.addSubview(segmentContainer)
        segmentContainer.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(10)
        }
        segmentContainer.addSubview(tabs)
        tabs.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(segmentContainer.snp.bottom)
        }
        let segmentedControl = UISegmentedControl(items: ["Seeding","Drying","Tea"])
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 1
        tabs.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(15)
        }
        segmentedControl.rx.value.distinctUntilChanged()
        .subscribe{print($0)}
        .disposed(by: disposeBag)

       

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

struct Root: Codable {
    let records : [dryingModel]
}
struct dryingModel: Codable{
    let id: String
    let createdTime: String
    let fields: dryingData
}

struct dryingData : Codable {
    
    let cropName: String?
    let dateHarvested: String?
    let plotNrow: String?
    let feetHarvested: Int?
    let plantPart: String?
    let harvestWeight: Int?
    let dryingCondition: String?
    let temp: Int?
    let humidity: Int?
    let dateDried: String?
    let dryWeight: Int?
    let processedWeight: Int?
    let lotNumber: String?
    
    private enum CodingKeys: String, CodingKey {
        case cropName = "Crop"
        case dateHarvested = "Harvest Date"
        case plotNrow = "Plot and Row"
        case feetHarvested = "Feet Harvested"
        case plantPart = "Plant Part"
        case harvestWeight = "Harvest Weight"
        case dryingCondition = "Drying Condition"
        case temp = "Temperature"
        case humidity = "Relative Humidity"
        case dateDried = "Date Dried"
        case dryWeight = "Dry Weight"
        case processedWeight = "Processed Weight"
        case lotNumber = "Lot Number"
    }
}

class APIClient<T:Codable> {

    func pull(url: String) -> Observable<([dryingModel])> {
        return request(.get, url).responseData()
            .map({ (Element) in
                do{
                    let  root = try JSONDecoder().decode(Root.self, from: Element.1)
                    return root.records
                }
                catch {
                    return [dryingModel.init(id: "Error", createdTime: "Error", fields: dryingData.init(cropName: "error", dateHarvested: nil, plotNrow: nil, feetHarvested: nil, plantPart: nil, harvestWeight: nil, dryingCondition: nil, temp: nil, humidity: nil, dateDried: nil, dryWeight: nil, processedWeight: nil, lotNumber: nil))]
                }
            })
    }
    
}



