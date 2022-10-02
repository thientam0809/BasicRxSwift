//
//  ProvinceViewModel.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/8/22.
//

import RxSwift
import RxRelay
import RxCocoa

class ProvinceViewModel {
    
    var provinceModelSubject = PublishSubject<[CountryListModel]>()
    // luu data thi dung BehaviorSubject

    private let isTableHidden = BehaviorRelay<Bool>(value: false)
    private let searchValueBehavior = BehaviorSubject<String?>(value: "")
    private let bag = DisposeBag()

    let filterProvinceObs: Observable<[CountryListModel]>
    var searchValueOberver: AnyObserver<String?> { searchValueBehavior.asObserver() }
    var provinceModelObs: Observable<[CountryListModel]> { provinceModelSubject }
    var isHiddenObs: Observable<Bool> { isTableHidden.asObservable()}

    init() {
        filterProvinceObs = Observable.combineLatest(
        searchValueBehavior
            .map { $0 ?? ""}
            .startWith("")
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance), provinceModelSubject
        )
            .map({ searchValue, lists in
                searchValue.isEmpty ? lists : lists.filter({ country in
                    country.name.lowercased().contains(searchValue.lowercased())
                })
            })
        }

    func getData() -> Single<[CountryListModel]>{
        return APIRequest.shared().getData1()
    }
}
