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
        handleBinding()
    }

    private func handleBinding() {
        
        // bind seach to viewModel
        let textObs = searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")

        let input = ProvinceViewModel.Input(reload: Driver.just(()), searchValue: textObs)

        let output = viewModel.transform(input: input)

        // handle data, bind viewModel2View
        output.cities
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (indexPath, list, cell) in
            cell.textLabel?.text = list.name
        }.disposed(by: bag)

        // handle error
        output.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] error in
                guard let this = self else { return }
                this.showAlert(alertMessage: error)
            })
            .disposed(by: bag)

        // handle selected
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
            guard let this = self else { return }
            this.tableView.deselectRow(at: indexPath, animated: false)
            let vc = LoginViewController()
            this.navigationController?.pushViewController(vc, animated: false)
        }
            .disposed(by: bag)
    }

    private func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func configTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}
