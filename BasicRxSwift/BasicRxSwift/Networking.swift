//
//  Networking.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 14/10/2022.
//

import Moya

var authenProvider: MoyaProvider<AuthenTargetType> = {
    #if DEBUG
        let plugins = [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        return MoyaProvider<AuthenTargetType>(stubClosure: MoyaProvider.immediatelyStub, plugins: plugins)
    #else
        let plugins = [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        return MoyaProvider<AuthenTargetType>(plugins: plugins)
    #endif
}()

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

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data {
        switch self {
        case .login:
            return Stubber.jsonDataFromFile("User")
        }
    }
}

class Stubber {
    class func jsonDataFromFile(_ fileName: String) -> Data {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid json file")
        }
        return data
    }
}
