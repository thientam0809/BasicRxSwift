//
//  ChangeAvatarViewController.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 7/28/22.
//

import UIKit
import RxSwift

final class ChangeAvatarViewController: UIViewController {

    // MARK: - Properties
    private let bag = DisposeBag()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
