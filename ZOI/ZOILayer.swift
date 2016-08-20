//
//  ZOILayer.swift
//  ZOI
//
//  Created by 田中賢治 on 2016/08/19.
//  Copyright © 2016年 田中賢治. All rights reserved.
//

import UIKit

extension CALayer {
    var center: CGPoint {
        return CGPoint(x: CGRectGetWidth(self.bounds) / 2.0, y: CGRectGetHeight(self.bounds) / 2.0)
    }
}

class ZOILayer: CALayer {
    var maskLayer: CAShapeLayer!
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 独自実装のinitializer
    init(center: CGPoint, size: CGSize, color: UIColor) {
        super.init()
        
        self.position = center
        self.bounds.size = size
        self.backgroundColor = color.CGColor
        self.cornerRadius = size.width / 2
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer.bounds.size = self.bounds.size
        self.maskLayer.position = self.center
        
        // 円形指定のPathのRectを生成
        let circleWidth: CGFloat = 1
        let circleHeight: CGFloat = 1
        let circleX = self.center.x - circleWidth / 2
        let circleY = self.center.y - circleHeight / 2
        
        let circleRect = CGRect(x: circleX, y: circleY, width: circleWidth, height: circleHeight)
        
        // 二つのPathを生成。この二つのパスの重なり具合によって塗りつぶしルールを考える
        let boundsPath = UIBezierPath(rect: self.bounds)
        let circlePath = UIBezierPath(ovalInRect: circleRect)
        boundsPath.appendPath(circlePath)
        
        self.maskLayer.fillRule = kCAFillRuleEvenOdd
        self.maskLayer.path = boundsPath.CGPath
        
        self.mask = self.maskLayer
    }
    
    // 縮小アニメーション
    func startReductionScaleAnimation(completionHandler: (() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        
        // setCompletionBlockはサイズ変更処理の前に書かないと即時実行されちゃいます！
        CATransaction.setCompletionBlock { completionHandler?() }
        transform = CATransform3DMakeScale(0.25, 0.25, 1)
        CATransaction.commit()
    }
    
    // 拡大アニメーション
    func startExpansionScaleAnimation(completionHandler: (() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        transform = CATransform3DMakeScale(10, 10, 1)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock { completionHandler?() }
        maskLayer.transform = CATransform3DMakeScale(300, 300, 1)
        
        CATransaction.commit()
        CATransaction.commit()
    }
    
}
