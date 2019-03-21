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

class ViewData: UIViewController, navDelegate, UITableViewDelegate{
    
    private let tableView = UITableView()
    private let label = UILabel()
    let reload = PublishSubject<Any>.init()
    let refreshObservable = BehaviorSubject<Void>(value: ())
    let segmentContainer = UIView()
    let tabs = UIView()
    let urls = [AirtableURls.seedViewData,AirtableURls.dryingViewData,AirtableURls.teaViewData]
    private let disposeBag = DisposeBag()
    let segment : ControlProperty<Int>
    let segmentedControl : UISegmentedControl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //These methods setup views and properties. I generally dislike having really long viewDidLoads()
        configureProperties()
        configureLayout()
        tableView.rx.itemSelected.throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as! CustomCell
            if let dataModel = cell.model {
                let infoView = DataViewPopUp(model: dataModel)
                infoView.navdelgate = self
                self?.view.addSubview(infoView)
                infoView.center = (self?.view.center)!
                self!.flipSubViews()
                infoView.rx.deallocated.subscribe{self?.flipSubViews()}.disposed(by: self!.disposeBag)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        segmentedControl = UISegmentedControl(items: ["Seeding","Drying","Tea"])
        segment = segmentedControl.rx.selectedSegmentIndex
        super.init(coder: aDecoder)
        segmentedControl.selectedSegmentIndex = 1
        refreshObservable.onNext(()) //Have to manually emit at the start.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //This is where the tableview is bound to the data
    private func configureProperties(){
        tableView.register(CustomCell.self, forCellReuseIdentifier: "dryingCell")
        //This emits when the ViewWillAppear,when a segment is selected,and when the RefreshObservable emits.
        let models = Observable.combineLatest(self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))), segment, refreshObservable){_ , index, _  in
                return self.urls[index]
            }.flatMapLatest({APIClient.pull(url: $0)})
        //Models is now a stream of dataModels
        models.flatMapLatest({data -> Observable<[dataModel]> in
            //This creates a stream with a blank header inserted at index 0
            var model = data
            model.insert(dataModel(id: "Header", createdTime: "Now", fields: AnyFormModel(index: self.segmentedControl.selectedSegmentIndex)), at: 0)
            return Observable.just(model)
        }).bind(to: tableView.rx.items(cellIdentifier: "dryingCell", cellType: CustomCell.self )){ index, model, cell in
            //Configures the cell according to which data it is given
            cell.layoutCell(model: model)
            }.disposed(by: disposeBag)
    }

    //Mostly used to set up the segmented control to be friendly with the tableview
    private func configureLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.layer.zPosition = 10
        tabs.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentContainer)
        segmentContainer.snp.makeConstraints{
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
        segmentedControl.layer.masksToBounds = true
        tabs.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(15)
        }
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    //Disables userinteraction when a popup view is
    //It is called when the View is instantiated and is called again when the view is deallocated. Also a way to force me to watch out for memory leaks :D
    @objc func flipSubViews(){
        for subs in self.view.subviews {
            if subs is DataViewPopUp{
                subs.isUserInteractionEnabled = true
            }
            else {
                subs.isUserInteractionEnabled = !subs.isUserInteractionEnabled
            }
        }
    }
    
    /*
    // Delegate function that lets me navigate from this viewcontroller to the formViewController needed when editing entries
    // The popUp view is specifically a UIView, so delegation was neccessary to let me navigate to the proper formView given info processed in the DataViewPopUp class
    */
    func navigate(viewController: DataViewForm) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    func refresh() {
        refreshObservable.onNext(())
    }
}
