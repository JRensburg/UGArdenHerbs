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
import CoreLocation
import SnapKit

class SplashViewController : UIViewController, CLLocationManagerDelegate {
    let herbLogo = UIImage(named: "ugardenherbslogo.png")
    private let locationManger = CLLocationManager()
    var currentLocation: CLLocation? = nil
    let ugarden : CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 33.903217, longitude: -83.374161), radius: 500.0, identifier: "ugarden")
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let imageView = UIImageView(image: herbLogo)
        let navigate = UITextField()
        locationManger.delegate = self
        locationManger.distanceFilter = kCLLocationAccuracyKilometer
        locationManger.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManger.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManger.startUpdatingLocation()
        }
        
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
        let textObserve = navigate.rx.text.orEmpty.debug().debounce(.milliseconds(300), scheduler: MainScheduler.instance).filter{$0 == AirtableURLs.appCode}
        textObserve.subscribe{ val in
            self.navAction()
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let coord = locationManger.location?.coordinate {
            if ugarden.contains(coord) {
                navAction()
            }
        }
    }
    func navAction() {
//        let top = UIApplication.shared.keyWindow?.rootViewController
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "IntroView") as! IntroViewController
//        let navigationController = UINavigationController.init(rootViewController: vc)
        navigationController?.setViewControllers([vc], animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, . authorizedAlways:
            if CLLocationManager.locationServicesEnabled(){
                self.locationManger.startUpdatingLocation()
                if let coord = locationManger.location?.coordinate {
                    if ugarden.contains(coord) {
                        navAction()
                    }
                }
            }
        case .restricted,.denied:
            break
        }
    }
}
