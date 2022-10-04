//
//  ProvinceViewModel.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/8/22.
//

import RxSwift
import RxRelay
import RxCocoa

class ProvinceViewModel: ViewModelType {

    struct Input {
        let reload: Driver<Void>
        let searchValue: Driver<String>
    }

    struct Output {
        let cities: Driver<[CountryListModel]>
        let error: Driver<String>
    }

    func transform(input: Input) -> Output {
        let errorRelay = PublishRelay<String>()
        let citis = input.reload
            .asObservable()
            .flatMapLatest({ APIRequest.shared().getData1() })
            .asDriver { error -> Driver<[CountryListModel]> in
            errorRelay.accept(error.localizedDescription)
            return Driver.just([])
        }

        let citisFilter = Observable.combineLatest(input.searchValue.asObservable()
                .map { $0 }
                .startWith("")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance),
            citis.asObservable()
        )
            .map { searchValue, lists in
            searchValue.isEmpty ? lists : lists.filter({ province in
    province.name.lowercased().contains(searchValue.lowercased())
})
        }
            .asDriver(onErrorJustReturn: [])
        return Output(cities: citisFilter, error: errorRelay.asDriver(onErrorDriveWith: Driver.just("Error happen")))
    }

    init() { }
}
