//
//  BaseTableViewController.swift
//  Base
//
//  Created by yleson on 2021/3/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class BaseTableViewController: BaseViewController {
    /// 列表模型
    var viewModel: ListViewModel!

    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        DispatchQueue.main.async {
            self.setupBindings()
        }

        loadItems()
    }

    /// 必须实现Cell注册
    var tableViewCellsToRegister: [String: UITableViewCell.Type] {
        fatalError()
    }
}

private extension BaseTableViewController {
    func setupUI() {
        self.tableViewCellsToRegister.forEach {
            self.tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
        self.view.addSubview(self.tableView)
    }

    func setupConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupBindings() {
        self.viewModel.listItems.bind(to: self.tableView.rx.items(dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, ListItemViewModel>>(configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: item)), for: indexPath)
            (cell as? ListItemCell)?.update(with: item)
            return cell
        }))).disposed(by: disposeBag)
    }

    func loadItems() {
        self.viewModel.hasError.onNext(false)
        let _ = self.viewModel.loadItems()
    }
}

