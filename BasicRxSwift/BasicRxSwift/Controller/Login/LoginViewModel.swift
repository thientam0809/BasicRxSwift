//
//  LoginViewModel.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/10/22.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    var username: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
    var loginTap: PublishSubject<Void> { get }
}

protocol LoginViewModelOutput {
    var errorUsername: Driver<Error?> { get }
    var errorPassword: Driver<Error?> { get }
    var submitButtonValidate: Driver<Bool> { get }
    var loginDone: Driver<Bool> { get }
}

protocol LoginViewModelFeature {
    var inputs: LoginViewModelInput { get }
    var outputs: LoginViewModelOutput { get }
}

final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput, LoginViewModelFeature {

    var inputs: LoginViewModelInput { return self }
    var outputs: LoginViewModelOutput { return self }

    // input
    var username: BehaviorRelay<String> = .init(value: "")
    var password: BehaviorRelay<String> = .init(value: "")
    var loginTap: PublishSubject<Void> = PublishSubject<Void>()

    // output
    var errorUsername: Driver<Error?> = .just(nil)
    var errorPassword: Driver<Error?> = .just(nil)
    var submitButtonValidate: Driver<Bool> = .just(false)
    var loginDone: Driver<Bool> = .just(false)

    init() {
        binding()
    }

    func binding() {
        let emailAndPasswordObservable: Observable<(String, String)> = Observable.combineLatest(username.asObservable(), password.asObservable())
        { ($0, $1) }

        let isEmpty: Observable<Bool> = emailAndPasswordObservable
            .asObservable()
            .map { email, password in
            email.isEmpty || password.isEmpty
        }

        errorUsername = username
            .asObservable()
            .map({ string in
            string.validPassword()
        })
            .asDriver(onErrorJustReturn: nil)

        errorPassword = password
            .asObservable()
            .map({ string in
            string.validPassword()
        })
            .asDriver(onErrorJustReturn: nil)

        submitButtonValidate = Observable.combineLatest(errorUsername.asObservable(), errorPassword.asObservable(), isEmpty)
        { $0 == nil && $1 == nil && $2 == false }
            .debug()
            .asDriver(onErrorJustReturn: false)

        let request = loginTap
            .asObservable()
            .flatMap { APIRequest.shared().getInformationUser() }

        loginDone = request
            .asObservable()
            .map { !($0.name?.isEmpty ?? false) }
            .debug()
            .asDriver(onErrorJustReturn: false)
    }
}

extension String {

    func validPassword() -> Error? {
        return count < 8 && count > 0 ? NSError.leastThan8Chars : nil
    }
}

extension NSError {

    static var leastThan8Chars: Error {
        return NSError(message: "leastThan8Chars")
    }
}


extension Error {

    init(message: String) {
        self = NSError(domain: Bundle.main.bundleIdentifier ?? "",
            code: 999, userInfo: [NSLocalizedDescriptionKey: message]) as! Self
    }
}
