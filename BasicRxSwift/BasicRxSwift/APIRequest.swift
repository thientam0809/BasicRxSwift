//
//  APIRequest.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/5/22.
//

import Foundation
import RxSwift

public enum RequestType: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkingError: Error {
    case invalidEmail(String)
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case invalidDecoderConfiguration
}

class APIRequest {

    private static var sharedInstance: APIRequest = {
        let shareRequest = APIRequest()
        return shareRequest
    }()

    class func shared() -> APIRequest {
        return sharedInstance
    }

    // initial
    private init() { }

    let baseURL = "https://api.printful.com/countries"
    var type = RequestType.GET
    var param = [String: String]()
    private let bag = DisposeBag()

    func getData1() -> Single<[CountryListModel]> {

        return Single<[CountryListModel]>.create { [weak self] observer -> Disposable in
            guard let this = self,
                let path = URL(string: "https://api.printful.com/countries") else {
                return Disposables.create()
            }

            let observable = Observable<URL>.just(path)
                .map { URLRequest(url: $0) }
                .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: urlRequest)
            }

            observable
                .subscribe { (response, data) in
                do {
                    let model: CountryModel = try JSONDecoder().decode(CountryModel.self, from: data)
                    observer(.success(model.result ?? []))
                } catch let error {
                    observer(.failure(error))
                }
            } onError: { error in
                observer(.failure(error))
            } .disposed(by: this.bag)

            return Disposables.create()
        }
            .observe(on: MainScheduler.instance)
    }
}
