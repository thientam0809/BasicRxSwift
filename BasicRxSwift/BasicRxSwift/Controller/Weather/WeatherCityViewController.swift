//
//  WeatherCityViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/1/22.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherCityViewController: UIViewController {

    // MARK: - IBOUlets
    @IBOutlet private weak var searchCityName: UITextField!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var cityNameLabel: UILabel!

    // MARK: - Properties
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        WeatherAPI.shared.currentWeather(city: "")
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] weather in
//                guard let this = self else { return }
//                this.cityNameLabel.text = weather.cityName
//                this.tempLabel.text = String(weather.temperature)
//                this.humidityLabel.text = String(weather.humidity)
//
//            })
//           .disposed(by: bag)

//        searchCityName.rx.text.orEmpty
//            .filter { !$0.isEmpty }
//            .flatMap { text in
//                return WeatherAPI.shared.currentWeather(city: "")
//
//            }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] weather in
//                guard let this = self else { return }
//            this.cityNameLabel.text = weather.cityName
//            this.tempLabel.text = String(weather.temperature)
//            this.humidityLabel.text = String(weather.humidity)
//
//            }).disposed(by: bag)

        let empty = Weather(cityName: "", temperature: 1, humidity: 1)
        let search = searchCityName.rx.text.orEmpty
            .filter { !$0.isEmpty }
            .flatMap { text in
            return WeatherAPI.shared.currentWeather(city: "")
        }
            .asDriver(onErrorJustReturn: empty)

        search.map { $0.cityName }
//            .bind(to: searchCityName.rx.text)
        .drive(cityNameLabel.rx.text)
            .disposed(by: bag)

        search.map { String($0.humidity) }
//            .bind(to: humidityLabel.rx.text)
        .drive(humidityLabel.rx.text)
            .disposed(by: bag)

        search.map { $0.cityName }
//            .bind(to: self.rx.title)
        .drive(cityNameLabel.rx.text)
            .disposed(by: bag)

    }
}

// create Binder Property
extension Reactive where Base: WeatherCityViewController {

    // base: chinh la viewController
    var title: Binder<String> {
        return Binder(self.base) { (vc, value) in
            vc.title = value
        }
    }
}
