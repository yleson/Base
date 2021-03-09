//
//  WaterfallLayout.swift
//  Base
//
//  Created by yleson on 2021/3/9.
//  瀑布流布局

import UIKit


@objc public protocol WaterfallLayoutDataSource {
    /// 返回每一个item的高度
    func itemHeight(_ layout : WaterfallLayout, indexPath : IndexPath) -> CGFloat
    /// 返回每一行多少列的item
    @objc optional func numberOfColsInWaterfallLayout(_ layout : WaterfallLayout) -> Int
}

open class WaterfallLayout: UICollectionViewFlowLayout {
    /// 数据源，外界传入
    public weak var dataSource : WaterfallLayoutDataSource?
    /// 保存每一个item属性
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    /// 记录总高度
    fileprivate var totalHeight : CGFloat = 0
    /// 记录每一列高度
    fileprivate lazy var colHeights : [CGFloat] = []
    /// 记录最大高度
    fileprivate var maxH : CGFloat = 0
    /// 开始拼接下标
    fileprivate var startIndex = 0
}

extension WaterfallLayout {
    /// prepare准备所有Cell的布局样式
    open override func prepare() {
        super.prepare()
        
        // 重置数据
        self.startIndex = 0
        self.maxH = 0
        self.totalHeight = 0
        self.attrsArray.removeAll()
        
        // 空数据直接返回
        guard collectionView!.numberOfSections > 0 else { return }
        
        var headHeight: CGFloat = 0
        if let headerAttri = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
            headHeight = headerAttri.frame.height
            headerAttri.frame = CGRect(x: headerAttri.frame.origin.x, y: self.sectionInset.top + headerAttri.frame.origin.y, width: headerAttri.frame.size.width, height: headerAttri.frame.size.height)
            headerAttri.zIndex = 29
            attrsArray.append(headerAttri)
        }
        
        // 0.获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        // 1.获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        self.colHeights = Array(repeating: self.sectionInset.top, count: cols)
        
        // 2.计算Item的宽度
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * CGFloat((cols - 1))) / CGFloat(cols)
        
        // 3.计算所有的item的属性
        for i in self.startIndex..<itemCount {
            // 1.设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 2.根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.获取高度
            guard let height = self.dataSource?.itemHeight(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            
            // 4.取出最小列的位置
            var minH = self.colHeights.min()!
            let index = self.colHeights.firstIndex(of: minH)!
            minH = minH + height + minimumLineSpacing
            self.colHeights[index] = minH
            
            // 5.设置item的属性
            attrs.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index), y: headHeight + minH - height - self.minimumLineSpacing, width: itemW, height: height)
            self.attrsArray.append(attrs)
        }
        
        // 4.记录最大值
        self.maxH = self.colHeights.max()!
        
        // 5.给startIndex重新复制
        self.startIndex = itemCount
    }
}

extension WaterfallLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
    
    open override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: self.maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
