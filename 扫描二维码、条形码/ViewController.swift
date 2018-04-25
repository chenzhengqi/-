//
//  ViewController.swift
//  扫描二维码、条形码
//
//  Created by LD on 2018/4/25.
//  Copyright © 2018年 LD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var codeBut : UIButton = {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        but.setTitle("扫描二维码", for: .normal)
        but.backgroundColor = .orange
        but.center = self.view.center
        return but
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(codeBut)
        codeBut.addTarget(self, action: #selector(codeClick), for: .touchUpInside)
    }
    
    @objc func codeClick()  {
        let vc = LDCode()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

