//
//  ViewController.swift
//  ImageScrollViewDemo
//
//  Created by Oleksandr Bezpalchuk on 7/24/19.
//  Copyright © 2019 Soultime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageScrollView.startAnimation()
    }
    
}

