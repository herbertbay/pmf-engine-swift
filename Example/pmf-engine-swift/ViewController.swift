//
//  ViewController.swift
//  pmf-engine-swift
//
//  Created by Nataliia on 07/25/2023.
//  Copyright (c) 2023 Nataliia. All rights reserved.
//

import UIKit
import pmf_engine_swift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    PMFEngine.default.trackKeyEvent("journal")
    PMFEngine.default.trackKeyEvent()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

