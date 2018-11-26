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
    var segmentedControl : UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureLayout()
        self.apiClient.pull(url: "https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8").bind(to: tableView.rx.items(cellIdentifier: "dryingCell", cellType: CustomCell.self )){ index, model, cell in
            cell.title.text = model.fields.cropName
            cell.date.text = ((model.fields.dateHarvested != "No value") ? "Harvested: " + model.fields.dateHarvested : "")
            cell.date2.text = ((model.fields.dateDried != "No value") ? "Dried: " + model.fields.dateDried : "")
            cell.model = model
            //cell.date.text = model.fields.dateDried ?? (model.fields.dateHarvested ?? "")
            //cell.model = model
        }.disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as! CustomCell
//            let popUp = dataPopUpViewController()
//            self!.view.addSubview(popUp.view)
//            popUp.view.snp.makeConstraints{
//               $0.center.equalToSuperview()
//                $0.height.width.equalToSuperview().dividedBy(1.5)
//            }
//            popUp.didMove(toParentViewController: self)
            let infoView = DataViewPopUp(section: (self?.segmentedControl!.selectedSegmentIndex)!, model: cell.model!)
            self?.view.addSubview(infoView)
            infoView.center = (self?.view.center)!
            self!.flipSubViews()
            infoView.rx.deallocated.subscribe{self?.flipSubViews()}.disposed(by: self!.disposeBag)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureProperties(){
        tableView.register(CustomCell.self, forCellReuseIdentifier: "dryingCell")
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
           // $0.edges.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.snp.top).inset((self.navigationController?.navigationBar.frame.size.height ?? 15) + 15)
            $0.height.equalToSuperview().dividedBy(12)
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
        segmentedControl = UISegmentedControl(items: ["Seeding","Drying","Tea"])
        segmentedControl!.layer.masksToBounds = true
        segmentedControl!.selectedSegmentIndex = 1
        tabs.addSubview(segmentedControl!)
        segmentedControl!.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(15)
        }
        segmentedControl!.rx.value
        .subscribe{print($0)}
        .disposed(by: disposeBag)
    }
    
    func flipSubViews(){
        for subs in self.view.subviews {
            if subs is DataViewPopUp{
                subs.isUserInteractionEnabled = true
            }
            else {
                subs.isUserInteractionEnabled = !subs.isUserInteractionEnabled
            }
        }
    }
    
}





//            let infoView = DataViewPopUp(section: (self?.segmentedControl!.selectedSegmentIndex)!, model: cell.model!)
//            self?.view.addSubview(infoView)
//            infoView.center = (self?.view.center)!e
//            self!.flipSubViews()
//            infoView.rx.deallocated.subscribe{self?.flipSubViews()}.disposed(by: self!.disposeBag)
