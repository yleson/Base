//
//  ListViewModel.swift
//  Base
//
//  Created by yleson on 2021/3/15.
//

import Foundation
import RxSwift
import RxDataSources

protocol ListViewModel {
    var listItems: BehaviorSubject<[SectionModel<String, ListItemViewModel>]> { get }
    var hasContent: Observable<Bool> { get }
    var hasError: BehaviorSubject<Bool> { get }

    func trackScreenviews()

    // Need the conformed class to implement
    func loadItems() -> Observable<Void>
}

extension ListViewModel {
    var hasContent: Observable<Bool> {
        return listItems.map(\.isEmpty).distinctUntilChanged().asObservable()
    }
}
