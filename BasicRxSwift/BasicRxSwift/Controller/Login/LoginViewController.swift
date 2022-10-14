//
//  LoginViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/10/22.
//

import RxSwift
import UIKit

final class LoginViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorUsernameLabel: UILabel!
    @IBOutlet private weak var errorPasswordLabel: UILabel!

    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 25
        }
    }

    // MARK: - Properties
    var viewModel = LoginViewModel()

    let bag = DisposeBag()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
    }

    private func binding() {

        // bind view to viewModel
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.username)
            .disposed(by: bag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.password)
            .disposed(by: bag)
        
        viewModel.outputs.errorUsername
            .drive(onNext: { [weak self] error in
                guard let this = self else { return }
                this.errorUsernameLabel.text = error?.localizedDescription
            })
            .disposed(by: bag)
        
        viewModel.outputs.errorPassword
            .drive(passwordValidationMessageBinder)
            .disposed(by: bag)
        
        viewModel.outputs.submitButtonValidate
            .drive(submitButton.rx.isEnabled)
            .disposed(by: bag)
        
        let buttonAction: Action<Void, Void> = Action {
            return Observable.empty()
        }
    }

    // MARK: - IBAction
    @IBAction private func submitButtonTouchUpInside(_ sender: UIButton) {
        let vc = ProvinceViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

// Extension create Binder de tao toi tuong ObserverType
extension LoginViewController {
    var userNameValidationMessageBinder: Binder<Error?> {
        return Binder(self) { vc, message in
            vc.errorUsernameLabel.text = message?.localizedDescription
        }
    }

    var passwordValidationMessageBinder: Binder<Error?> {
        return Binder(self) { vc, message in
            vc.errorPasswordLabel.text = message?.localizedDescription
        }
    }

//    var enableSubmitButton: Binder<Bool> {
//        return Binder(self) { vc, isEnabled in
////            vc.submitButton.isEnabled = !isEnabled
////            vc.submitButton.backgroundColor?.withAlphaComponent(isEnabled) ?? 0 ? 1 : 0.4
////            vc.submitButton.rx.is
//            vc.submitButton.isEnabled = !isEnabled
//            vc.submitButton.backgroundColor?.withAlphaComponent(isEnabled) ? 1 : 0.4
//        }
//    }
}
