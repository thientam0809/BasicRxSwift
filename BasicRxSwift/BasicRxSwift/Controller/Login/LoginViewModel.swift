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

final class LoginViewModel: ViewModel {
    
    struct Input {
        let username: Driver<String>
        let password: Driver<String>
        let login: Driver<Void>
    }
    
    struct Output {
        @Property var usernameValidateMessage: String = ""
        @Property var passwordValidateMessage: String = ""
        @Property var isLoginEnabled: Bool = true
        @Property var isLoading: Bool = false
        @Property var error: Error?
    }
    
    func transform(_ input: Input, disposeBad: DisposeBag) -> Output {
        let output = Output()
        
        let activityIndicator = ActivityIndicator()
        
        
        // loading
        let isLoading = activityIndicator.asDriver()
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBad)
        
        // validate username
        let usernameValidate = Driver.combineLatest(input.username, input.login)
            .map { $0.0 }
            .map { $0.validPassword() }

        usernameValidate
            .compactMap { $0?.localizedDescription }
            .drive(output.$usernameValidateMessage)
            .disposed(by: disposeBad)
        
        // validate password
        let passwordValidate = Driver.combineLatest(input.password, input.login)
            .map { $0.0 }
            .map { $0.validPassword() }
        
        passwordValidate
            .compactMap { $0?.localizedDescription }
            .drive(output.$passwordValidateMessage)
            .disposed(by: disposeBad)
        
            // validate both
        let validate = Driver.combineLatest(usernameValidate, passwordValidate)
            .map { $0 != nil && $1 != nil }
            .startWith(false)
        
        validate
            .drive(output.$isLoginEnabled)
            .disposed(by: disposeBad)
        
        input.login
            .withLatestFrom(validate)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(input.username, input.password))
//            .flatMapLatest { username, password -> Driver<Void> in
//                <#code#>
//            }
            .drive()
            .disposed(by: disposeBad)
        
        
        return output
    }
}

//    // input
//    var username: BehaviorRelay<String?> = BehaviorRelay(value: nil)
//    var password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
//    var loginTap: PublishSubject<Void> = PublishSubject<Void>()
//
//    //  output
//    var emailValidate: Driver<Error?>
//    var passwordValidate: Driver<Error?>
////    var submitButtonValidate: Driver<Error?>
//
//    init() {
//        emailValidate = username.asObservable()
//            .debug("Validate email")
//            .map { $0?.validPassword() }
//            .asDriver(onErrorJustReturn: nil)
//
//        passwordValidate = password.asObservable()
//            .debug("Validate password")
//            .map { $0?.validPassword() }
//            .asDriver(onErrorJustReturn: nil)
//    }
//}
//
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
