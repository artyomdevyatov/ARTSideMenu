//
//  ContentViewController.swift
//  sidemenu-example
//
//  Created by Artyom Devyatov on 27/03/16.
//  Copyright © 2016 Artyom Devyatov. All rights reserved.
//

import UIKit
import ARTSideMenu

class ContentViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Events

    @IBAction private func menuButtonTapped(sender: UIBarButtonItem) {
        ARTSideMenuController.sharedController.showMenuAnimated(true)
    }

}
