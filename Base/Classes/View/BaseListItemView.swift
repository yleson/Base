//
//  BaseListItemView.swift
//  Base
//
//  Created by yleson on 2021/3/15.
//

import UIKit
import RxSwift

protocol ListItemView: AnyObject {
    func update(with viewModel: ListItemViewModel)
}

class BaseListItemView: UIView, ListItemView {
    lazy var disposeBag: DisposeBag = .init()

    func update(with viewModel: ListItemViewModel) {
        fatalError()
    }
}
