//
//  HomeModel.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 7/29/22.
//

import Foundation
import RxSwift

enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error"
        }
    }
}

final class HomeModel {
    
    // singeton
    private static var shareHomeModel: HomeModel = {
        let shareHomeModel = HomeModel()
        return shareHomeModel
    }()
    
    class func shared() -> HomeModel {
        return shareHomeModel
    }
    
    private init() {}
    
    func register(userName: String?, password: String?, email: String?) -> Observable<Bool> {
        // custom Observable
        return Observable.create { observer in
            
            if let userName = userName {
                if userName.isEmpty {
                    observer.onError(APIError.error("user name is empty"))
                }
            } else {
                observer.onError(APIError.error("user name is nil"))
            }
            
            
            if let password = password {
                if password.isEmpty {
                    observer.onError(APIError.error("password is empty"))
                }
            } else {
                observer.onError(APIError.error("password is nil"))
            }
            
            if let email = email {
                if email.isEmpty {
                    observer.onError(APIError.error("email is empty"))
                }
            } else {
                observer.onError(APIError.error("email is nil"))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
