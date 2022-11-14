//
//  LoginViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/10/22.
//

import RxSwift
import UIKit
import RxCocoa
import Action

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
        
        let buttonAction: Action<Void, Void> = Action {
            return Observable.empty()
        }
        
        submitButton.rx.action = buttonAction
        
        submitButton.rx.tap
            .asObservable()
            .bind(onNext: { _ in
                self.viewModel.inputs.loginTap.onNext(())
            })
            .disposed(by: bag)

        // bind viewMode2View
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
        
        viewModel.outputs.loginDone
            .asObservable()
            .subscribe { [weak self] event in
                guard let this = self else { return }
                if let done = event.element, let isDone = done?.username, !isDone.isEmpty {
                    let vc = ProvinceViewController()
                    vc.viewModel = ProvinceViewModel(load: .just(()), nameUser: this.viewModel.loginDone)
                    this.navigationController?.pushViewController(vc, animated: false)
                }
            }.disposed(by: bag)
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
}
