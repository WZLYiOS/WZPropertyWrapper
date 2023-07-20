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

    
    @UserDefaultJsonWrapper("aaaaaa")
    var model: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.model = ViewModel()
        debugPrint(model?.ub)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapActopn)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    
    @objc private func tapActopn() {
        model?.ub = 7
        debugPrint(model?.ub)
    }
}

struct ViewModel: Codable {
    
    
    
    var ub: Int = 0
}
