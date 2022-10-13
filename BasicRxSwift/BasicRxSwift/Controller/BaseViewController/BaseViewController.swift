//
//  BaseViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 11/10/2022.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

protocol BaseViewProtocol: AnyObject {
    func startAnimating()
    func stopAnimating()
}

typealias HUD = SVProgressHUD
class BaseViewController: UIViewController, BaseViewProtocol {
    func startAnimating() {
        HUD.show()
    }

    func stopAnimating() {
        HUD.dismiss()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
