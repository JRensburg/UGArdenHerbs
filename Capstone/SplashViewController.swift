//
//  SplashViewController.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 1/8/19.
//  Copyright © 2019 NMI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SplashViewController : UIViewController {
    let herbLogo = UIImage(named: "ugardenherbslogo.png")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: herbLogo)
        var navigate = UITextField()
        
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFit
        view.addSubview(navigate)
        navigate.snp.makeConstraints{
            $0.top.equalToSuperview().inset(25)
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
        }
        navigate.placeholder = "Password"
        navigate.layer.cornerRadius = 15
        navigate.backgroundColor = UIColor.lightGray
        navigate.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: navigate.frame.height))
        navigate.leftViewMode = .always
        let textObserve = navigate.rx.text.orEmpty.debounce(0.3, scheduler: MainScheduler.instance).filter{$0 == "Holybasil"}//.subscribe{self.navAction()}.disposed(by: DisposeBag())
        textObserve.debug().subscribe{ val in
            print(val)
            self.navAction()
            
        }//.dispose()
        
//        navigate.setTitle("Navigate", for: .normal)
//        navigate.backgroundColor = .magenta
//        navigate.addTarget(self, action: #selector(navAction), for: .touchUpInside)
    }
    func navAction() {
        print("trying")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
        
    }
}
