//
//  BaseTableViewCell.swift
//  Base
//
//  Created by yleson on 2021/3/15.
//

import UIKit
import SnapKit

/// 更新数据
protocol ListItemCell: AnyObject {
    func update(with viewModel: ListItemViewModel)
}

final class BaseTableViewCell<V: BaseListItemView>: UITableViewCell, ListItemCell {
    private let view: V

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.view = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func update(with viewModel: ListItemViewModel) {
        view.update(with: viewModel)
    }
}
