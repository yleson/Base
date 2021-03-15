//
//  BaseViewController.swift
//  Base
//
//  Created by yleson on 2021/3/14.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    lazy var disposeBag: DisposeBag = .init()

    init() {
      super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "We don't support init view controller from a nib.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "We don't support init view controller from a nib.")
    required init?(coder: NSCoder) {
        fatalError()
    }
}

