//
//  LoginViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/10/22.
//

import RxSwift
import UIKit

//final class LoginViewController: UIViewController {
//
//    // MARK: - IBOutlet
//    @IBOutlet private weak var usernameTextField: UITextField!
//    @IBOutlet private weak var passwordTextField: UITextField!
//    @IBOutlet private weak var errorUsernameLabel: UILabel!
//    @IBOutlet private weak var errorPasswordLabel: UILabel!
//
//    @IBOutlet private weak var submitButton: UIButton! {
//        didSet {
//            submitButton.layer.cornerRadius = 25
//        }
//    }
//
//    // MARK: - Properties
//    var viewModel = LoginViewModel()
//
//    let bag = DisposeBag()
//
//    // MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bindtoViewModel()
//    }
//
//
//    private func bindtoViewModel() {
//        let input = LoginViewModel.Input(username: usernameTextField.rx.text.orEmpty.asDriver(), password: passwordTextField.rx.text.orEmpty.asDriver(), login: submitButton.rx.tap.asDriver())
//
//        let output = viewModel.transform(input, disposeBad: bag)
//
//        output.$usernameValidateMessage
//            .asDriver()
//            .drive(userNameValidationMessageBinder)
//            .disposed(by: bag)
//
//        output.$passwordValidateMessage
//            .asDriver()
//            .drive(passwordValidationMessageBinder)
//            .disposed(by: bag)
//
//        output.$isLoginEnabled
//            .asDriver()
//            .drive(enableSubmitButton)
//            .disposed(by: bag)
//
//    }
//
//    // MARK: - IBAction
//    @IBAction private func submitButtonTouchUpInside(_ sender: UIButton) {
//        let vc = ProvinceViewController()
//        navigationController?.pushViewController(vc, animated: false)
//    }
//}

// Extension create Binder de tao toi tuong ObserverType
//extension LoginViewController {
//    var userNameValidationMessageBinder: Binder<String> {
//        return Binder(self) { vc, message in
//            vc.errorUsernameLabel.text = message
//        }
//    }
//
//    var passwordValidationMessageBinder: Binder<String> {
//        return Binder(self) { vc, message in
//            vc.errorPasswordLabel.text = message
//        }
//    }
//    
//    var enableSubmitButton: Binder<Bool> {
//        return Binder(self) { vc, isEnabled in
//            vc.submitButton.isEnabled = !isEnabled
////            vc.submitButton.backgroundColor?.withAlphaComponent(isEnabled) ?? 0 ? 1 : 0.4
//        }
//    }
//}
