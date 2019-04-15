//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by Wojciech Kulik on 14/04/2019.
//  Copyright © 2019 Wojciech Kulik. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let pairingFlow = PairingFlow()
    var pairing: Disposable?
    
    @IBAction func pairClicked() {
        self.pairing?.dispose()
        self.pairing = self.pairingFlow.pair()
            .debug("vc")
            // .retry(2) // <-- simple retry implementation
            .materialize()
            .filter { !$0.isCompleted }
            .map { $0.error != nil ? "Error: \($0.error!)" : "Status: \($0.element!)" }
            .bind(to: self.statusLabel.rx.text)
    }
    
    @IBAction func cancelClicked() {
        self.pairing?.dispose()
        self.pairing = nil
        self.statusLabel.text = "Status: none"
    }
}
