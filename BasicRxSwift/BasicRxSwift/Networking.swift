//
//  Networking.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 14/10/2022.
//

import Moya

var authenProvider: MoyaProvider<AuthenTargetType>

enum AuthenTargetType {
    case login(userName: String, password: String)
}

extension AuthenTargetType: TargetType {
    var baseURL: URL {
        return URL(string: "https://rxproject.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let userName, let password):
            return .requestParameters(parameters: ["user": userName,
                                                   "pw": password], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return Stubber.jsonDataFromFile("User")
        }
    }
}
