//
//  ProvinceViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/4/22.
//

import UIKit
import RxSwift
import RxCocoa

final class ProvinceViewController: UIViewController {

    // MARK: - IBOutlet

    // MARK: - Properties
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    private let bag = DisposeBag()
    var viewModel = ProvinceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Citis"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        configTableView()

        viewModel.getData()
            .subscribe { lists in
            let subject = Observable.of(lists)
            subject
                .bind(to: self.viewModel.provinceModelSubject)
                .dispose()
        } onFailure: { error in
            let alert = UIAlertController(title: "Hello error", message: error.localizedDescription, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }.disposed(by: bag)

        handleObservable()

        bindToSearchValue()
    }

    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    private func handleObservable() {
//         create observable
        viewModel.filterProvinceObs
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (index, item, cell) in
            cell.textLabel?.text = item.name

        }
            .disposed(by: bag)
    }

    private func handleDeSelected() {
        tableView.rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
            print("Deselect with indexPath: \(indexPath)")
        }).disposed(by: bag)
    }

    private func handleDelegate() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }

    private func bindToSearchValue() {
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debug()
            .bind(to: viewModel.searchValueOberver)
            .disposed(by: bag)
    }
}

// MARK: - Extension UITableViewDelegate
extension ProvinceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}
