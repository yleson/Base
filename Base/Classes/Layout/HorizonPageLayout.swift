//
//  HorizonPageLayout.swift
//  Base
//
//  Created by yleson on 2021/3/9.
//  横向分页布局

import Foundation

open class HorizonPageLayout: UICollectionViewFlowLayout {
    
    /// 记录每一个item属性
    fileprivate var attributesArrayM = [UICollectionViewLayoutAttributes]()
    
    /// 设置方阵
    open func rowCountItem(rowCount: NSInteger, countPerRow: CGFloat) {
        self.rowCount = rowCount
        self.countPerRow = countPerRow
    }
    
    /// 设置间距
    open func columnSpacing(columnSpacing: CGFloat, rowSpacing: CGFloat, edge: UIEdgeInsets) {
        self.edgeInsets = edge
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
    }

    private lazy var rowCount: NSInteger = {
        let rowCount: NSInteger = 1
        return rowCount
    }()

    private lazy var countPerRow: CGFloat = {
        let countPerRow: CGFloat = 1
        return countPerRow
    }()

    private lazy var edgeInsets: UIEdgeInsets = {
        let edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return edgeInsets
    }()

    private lazy var columnSpacing: CGFloat = {
        let columnSpacing: CGFloat = 0
        return columnSpacing
    }()

    private lazy var rowSpacing: CGFloat = {
        let rowSpacing: CGFloat = 0
        return rowSpacing
    }()
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    public override init() {
        super.init()
        self.minimumLineSpacing = CGFloat.leastNormalMagnitude
        self.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        self.scrollDirection = .horizontal
    }
    
    open override func prepare() {
        super.prepare()
        
        let itemTotalCount = (collectionView!.numberOfItems(inSection: 0))
        
        for i in 0..<itemTotalCount {
            let indexPath = IndexPath.init(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath)
            attributesArrayM.append(attributes)
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArrayM
    }

    open override var collectionViewContentSize: CGSize {
        // 是否分页
        let isPagingEnabled = collectionView?.isPagingEnabled ?? false
        // 是分页则每页都需要减去edgeInsets.left + edgeInsets.right, 非分页只减去edgeInsets.left
        let edgeWidth: CGFloat = self.edgeInsets.left + (isPagingEnabled ? self.edgeInsets.right : 0)
        // 每一个cell的宽度
        let itemWidth = CGFloat.init((collectionView!.frame.size.width - edgeWidth - (self.countPerRow - 1) * self.columnSpacing) / self.countPerRow)
        // 一共有多少个cell
        let itemTotalCount: NSInteger = (collectionView?.numberOfItems(inSection: 0))!
        
        // 计算总宽度
        var width: CGFloat = 0
        if isPagingEnabled {
            // 每页矩阵排列共有多少个cell
            let itemCount: NSInteger = self.rowCount * Int(self.countPerRow)
            // 除去所有整页的还有多少个cell
            let remainder: NSInteger = NSInteger(itemTotalCount % itemCount)
            // 页数
            var pageNumber: NSInteger = itemTotalCount / itemCount
            if itemTotalCount <= itemCount {
                // 只有一页
                pageNumber = 1;
            } else {
                if remainder != 0 {
                    // 有剩余的就加一页
                    pageNumber = pageNumber + 1
                }
            }
            width = CGFloat(pageNumber) * collectionView!.frame.size.width
        } else {
            // 非分页情况
            width = self.edgeInsets.left + self.edgeInsets.right + CGFloat(itemTotalCount) * (itemWidth + self.columnSpacing) - self.columnSpacing
        }
        return  CGSize(width: width, height: 0)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes  {
        // 是否分页
        let isPagingEnabled = collectionView?.isPagingEnabled ?? false
        // 是分页则每页都需要减去edgeInsets.left + edgeInsets.right, 非分页只减去edgeInsets.left
        let edgeWidth: CGFloat = self.edgeInsets.left + (isPagingEnabled ? self.edgeInsets.right : 0)
        // 每一个cell的宽度
        let itemWidth = CGFloat.init((collectionView!.frame.size.width - edgeWidth - (self.countPerRow - 1) * self.columnSpacing) / self.countPerRow)
        // 每一个cell的高度
        let itemHeight: CGFloat = (collectionView!.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - CGFloat(self.rowCount - 1) * self.rowSpacing) / CGFloat(self.rowCount)
        // 当前是第几个
        let item = indexPath.item
        // 计算Frame
        var itemX: CGFloat = 0
        var itemY: CGFloat = 0
        if isPagingEnabled {
            // 分页情况，计算出当前页数
            let pageNumber: NSInteger = NSInteger(item) / (self.rowCount * NSInteger(self.countPerRow))
            let y: CGFloat = CGFloat(item / Int(self.countPerRow)) - CGFloat(pageNumber * self.rowCount)
            let preWidth: CGFloat = collectionView!.frame.size.width * CGFloat(pageNumber)
            
            itemX = preWidth + self.edgeInsets.left + CGFloat(item % Int(self.countPerRow)) * (itemWidth + self.columnSpacing)
            itemY = self.edgeInsets.top + (itemHeight + self.rowSpacing) * y
        } else if self.rowCount > 1 {
            itemX = self.edgeInsets.left + CGFloat(item % Int(self.countPerRow)) * (itemWidth + self.columnSpacing)
            itemY = self.edgeInsets.top + CGFloat(item / Int(self.countPerRow)) * (itemHeight + self.columnSpacing)
        } else {
            itemX = self.edgeInsets.left + CGFloat(item) * (itemWidth + self.columnSpacing)
            itemY = self.edgeInsets.top
        }
        
        let attributes = super.layoutAttributesForItem(at: indexPath as IndexPath) ?? UICollectionViewLayoutAttributes.init()
        attributes.frame = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)

        return attributes
    }
}
