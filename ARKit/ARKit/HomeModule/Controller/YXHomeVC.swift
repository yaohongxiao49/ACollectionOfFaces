//
//  YXHomeVC.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

class YXHomeVC: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationView.backgroundColor = UIColor.clear
        self.navigationView.titleLab.text = "首页"
        self.view.backgroundColor = UIColor.yxColorWithHexString(hex: "#F5F5F5")
        
        initView()
    }
    
    //MARK:- 初始化视图
    func initView() {
        
    }
}
