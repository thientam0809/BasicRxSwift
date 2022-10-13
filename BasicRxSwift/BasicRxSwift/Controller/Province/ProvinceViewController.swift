//
//  ProvinceViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/4/22.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

final class ProvinceViewController: BaseViewController {

    // MARK: - IBOutlet

    // MARK: - Properties
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    private let bag = DisposeBag()
    var viewModel = ProvinceViewModel(load: .just(()))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Citis"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        configTableView()
        handleBinding()
        bindView2ViewModel()
    }

    private func handleBinding() {
        
        viewModel.showLoading.asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: HUD.rx.isAnimating)
            .disposed(by: bag)

        // handle data, bind viewModel2View
        viewModel.outputs.cities
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { _ in self.viewModel.showLoading.accept(false) })
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (indexPath, list, cell) in
            cell.textLabel?.text = list.name
        }.disposed(by: bag)

        // handle error
        viewModel.outputs.error
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
//            let vc = LoginViewController()
//            this.navigationController?.pushViewController(vc, animated: false)
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
    
    private func bindView2ViewModel() {
        searchController.searchBar.rx.text
            .bind(to: viewModel.inputs.searchValue)
            .disposed(by: bag)
    }
}

extension Reactive where Base: SVProgressHUD {

    public static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { progressHUD, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }

}
