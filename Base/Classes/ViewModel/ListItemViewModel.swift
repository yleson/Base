//
//  ListItemViewModel.swift
//  Base
//
//  Created by yleson on 2021/3/15.
//

import Foundation

protocol ListItemViewModel {
    static var reuseIdentifier: String { get }
}

extension ListItemViewModel {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

