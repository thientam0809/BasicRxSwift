//
//  HomeViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 7/27/22.
//

import UIKit
import RxSwift
import RxRelay

final class HomeViewController: UIViewController {

    // MARK: - IBOulets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Properties
    private let bag = DisposeBag()
    private let image = BehaviorRelay<UIImage?>(value: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        // subcription
        image
            .subscribe { image in
                self.avatarImageView.image = image
            }.disposed(by: bag)

    }

    func configUI() {
        avatarImageView.layer.cornerRadius = 50.0
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.masksToBounds = true

        let leftBarButton = UIBarButtonItem(title: "Change Avatar", style: .plain, target: self, action: #selector(self.changeAvatar))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

    @objc private func changeAvatar() {
        let img = UIImage(systemName: "face.smiling")
        image.accept(img)
    }

    @IBAction private func register(_ sender: UIButton) {

    }

    @IBAction private func clear(_ sender: UIButton) {

    }
}
