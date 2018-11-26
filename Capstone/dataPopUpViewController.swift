//
//  dataPopUpViewController.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 11/25/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import SnapKit
import Eureka

class dataPopUpViewController: FormViewController {

    var model : dryingModel? = nil
    let update = UIButton()
    let delete = UIButton()
    let remove = UIButton()
    
    init(){
        super.init(style: .plain)
        self.view.layer.cornerRadius = 10
        self.view.layer.shadowColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureForm()
        self.view.backgroundColor = .green
        self.tableView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.bottom.equalTo(update.snp.top)
            $0.top.equalTo(remove.snp.bottom)
            $0.width.equalToSuperview().inset(15)
        }
        remove.bringSubview(toFront: self.view)
        // Do any additional setup after loading the view.
    }
    
    func configureForm(){
        form +++ Section("Tea Production")
            <<< DateRow("Date"){
                $0.title = "Date"
            }
            <<< TextRow("Tea Blend"){
                $0.title = "Tea Blend"
            }
            <<< TextRow("Batch Number"){
                $0.title = "Batch Number"
        }
    }
    
    func configureButtons(){
        self.view.addSubview(remove)
        remove.setImage(UIImage(named: "Return.png"), for: .normal)
        
        remove.imageView?.contentMode = .scaleAspectFit
        
        remove.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(10)
            $0.width.equalToSuperview().dividedBy(4)
        }
        remove.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(update)
        update.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 0.8)
        update.setTitle("Edit Record", for: .normal)
        
        update.snp.makeConstraints{
            $0.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        self.view.addSubview(delete)
        delete.setTitle("Delete Record", for: .normal)
        delete.backgroundColor = UIColor(red: 212/255, green: 4/255, blue: 36/255, alpha: 0.8)
        delete.snp.makeConstraints{
            $0.right.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        update.layer.cornerRadius = 10
        delete.layer.cornerRadius = 10
    }
    
    @objc func buttonTapped() -> Void {
        self.view.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
