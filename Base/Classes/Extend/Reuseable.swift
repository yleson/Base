//
//  Reuseable.swift
//  Base
//
//  Created by yleson on 2021/2/23.
//

import UIKit

// MARK: Xib注册Cell
public protocol NibLoadable: class {}
public extension NibLoadable where Self: UIView {
    public static var NibName: String {
        return String.init(describing: self)
    }
    public static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

// MARK: 代码注册Cell
public protocol ReusableView: class {}
public extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String.init(describing: self)
    }
}

// MARK: UITableView
extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func register<T: UITableViewCell>(_ : T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

// MARK: UICollectionView
extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func register<T: UICollectionViewCell>(_ : T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    
    public func registerHeader<T: UICollectionReusableView>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerHeader<T: UICollectionReusableView>(_ : T.Type) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableHeaderView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue header with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
    
    
    public func registerFooter<T: UICollectionReusableView>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }
    
    public func registerFooter<T: UICollectionReusableView>(_ : T.Type) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableFooterView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue footer with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}
