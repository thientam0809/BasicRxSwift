//
//  ProvinceViewModel.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/8/22.
//

import RxSwift
import RxRelay
import RxCocoa

protocol ProvinceViewModelInput {
    var load: Driver<Void> { get }
    var searchValue: BehaviorRelay<String?> { get }
}

protocol ProvinceViewModelOutput {
    var cities: Driver<[CountryListModel]> { get }
    var error: PublishRelay<String> { get }
    var showLoading: BehaviorRelay<Bool> { get }
}

protocol ProvinceFeature {
    var inputs: ProvinceViewModelInput { get }
    var outputs: ProvinceViewModelOutput { get }
}

final class ProvinceViewModel: ProvinceFeature, ProvinceViewModelInput, ProvinceViewModelOutput {

    var inputs: ProvinceViewModelInput { return self }
    var outputs: ProvinceViewModelOutput { return self }
    private let bag = DisposeBag()

    // inputs
    var load: Driver<Void>
    var searchValue: BehaviorRelay<String?> = .init(value: nil)

    // output
    var cities: Driver<[CountryListModel]> = .just([])
    var error = PublishRelay<String>()
    var showLoading: BehaviorRelay<Bool> = .init(value: false)

    init(load: Driver<Void>) {
        self.load = load
        bind()
    }

    private func bind() {
        let citiesTemp = load.asObservable()
            .do { _ in
            self.showLoading.accept(true)
        }
            .flatMap { _ in
            APIRequest.shared().getData1()
        }
            .do { _ in
            self.showLoading.accept(false)
        }
            .asDriver { error in
            self.error.accept(error.localizedDescription)
            return Driver.just([])
        }

        cities = Observable.combineLatest(searchValue.asObservable()
                .compactMap { $0 }
                .startWith("")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),
                                               citiesTemp.asObservable()
        )
            .map { searchValue, lists in
            searchValue.isEmpty ? lists : lists.filter({ province in
    province.name.lowercased().contains(searchValue.lowercased())
})
        }
            .asDriver(onErrorJustReturn: [])
    }
}
