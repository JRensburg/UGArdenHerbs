//
//  DataViewPopUp.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 11/8/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class DataViewPopUpController: UIViewController, UITableViewDelegate {

    private let tableView = UITableView()
    let dispose = DisposeBag()
    let model: dataModel
    var modelDict = [String:Any]()
    lazy var values = modelDict.sorted(by: {$0.0 < $1.0})
    var toolBar = UIToolbar()
    let update = UIButton()
    let delete = UIButton()
    let remove = UIButton()
    
    ///Stores a reference to the parent controller to set in motion the events surrounding refreshing the content
    weak var refreshObservable: BehaviorSubject<Void>?
    init(model: dataModel, refreshObservable: BehaviorSubject<Void>?){
        self.model = model
        self.refreshObservable = refreshObservable
        super.init(nibName: nil, bundle: nil)
        configureButtons()
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        
        tableView.rx.setDelegate(self).disposed(by: dispose)
        view.backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        tableView.allowsSelection = false
        configureCells()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /**
     This function adds the edit and delete buttons to the view and also adds their handlers
     It also creates the constraints for both
    */
    func configureButtons(){
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonTapped))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        toolBar.setItems([dismissButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), editButton, deleteButton], animated: true)
        view.addSubview(remove)

        tableView.backgroundView = nil
    }
    
    /**
     This function adds the tableView to the superview and also binds the dictionary of data to the tableView
     */
    func configureCells(){
        tableView.register(DisplayFieldCell.self, forCellReuseIdentifier: "dryCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.width.equalToSuperview()//.inset(15)
            $0.top.equalTo(toolBar.snp.bottom)
            $0.bottom.equalToSuperview().offset(16)
//            $0.height.equalToSuperview().multipliedBy(0.85) //was .78
            $0.centerX.equalToSuperview()
        }
        
        tableView.layer.borderWidth = 1
        
        modelDict = model.fields.value.dictionary
        
        Observable.from(optional: values).bind(to: tableView.rx.items(cellIdentifier: "dryCell", cellType: DisplayFieldCell.self)){index, element, cell in
            cell.key.text = element.key
            var val = element.value
            if val as? Int == -1 {
                val = "No Number"
            }
            cell.value.text = "\(val)"
            cell.key.font = .preferredFont(forTextStyle: .title3)
            cell.value.font = .preferredFont(forTextStyle: .title3)
            }.disposed(by: dispose)
    }
    
    @objc func buttonTapped() -> Void {
        dismiss(animated: true, completion: nil)
//        willMove(toParentViewController: nil)
//        view.removeFromSuperview()
//        removeFromParentViewController()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    @objc func editTapped() -> Void {
        let formView = DataViewForm(style: .grouped, model: model)
        (self.presentingViewController as? UINavigationController)?.pushViewController(formView, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func deleteTapped() -> Void {
        var delUrls : String?
        if (model.fields.value is SeedingData) {
            delUrls = AirtableURLs.seedingBase+model.id
        }
        else if (model.fields.value is DryingData) {
            delUrls = AirtableURLs.dryingBase+model.id
        }
        else if (model.fields.value is TeaData) {
            delUrls = AirtableURLs.teaBase+model.id
        }
        delUrls?.append("?" + AirtableURLs.authentication)
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.sendDelete(url: delUrls!)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func sendDelete(url: String){
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {[weak self] response in
            print(response)
            self?.refreshObservable?.onNext(())
        }
    }
}
