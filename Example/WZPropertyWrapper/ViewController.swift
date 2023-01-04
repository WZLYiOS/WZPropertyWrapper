//
//  ViewController.swift
//  WZPropertyWrapper
//
//  Created by LiuSky on 08/14/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import UIKit
import WZPropertyWrapper

class ViewController: UIViewController {

    
    @UserDefaultCodable("com.wz.ly", defaultValue: ViewModel())
    var model: ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(model.ub)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapActopn)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    
    @objc private func tapActopn() {
        model.ub = 7
        model.save()
        debugPrint(model.ub)
        
        model.ub = 8
        model.save()
        debugPrint(model.ub)
        
        model.ub = 11
        model.remove()
        debugPrint(model.ub)
    }
}

class ViewModel: Codable, UserDefaultCodableStorage {
    
    
    
    var ub: Int = 0
}
