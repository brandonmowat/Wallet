//
//  WalletViewController.swift
//  Wallet
//
//  Created by Brandon Mowat on 2017-06-14.
//  Copyright © 2017 Brandon Mowat. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    var walletView: WalletView?
    override func viewDidLoad() {
        super.viewDidLoad()
        walletView = WalletView(frame: self.view.frame)
        self.view.addSubview(walletView!)
    }
}
