//
//  ViewController.swift
//  ZOI
//
//  Created by 田中賢治 on 2016/08/19.
//  Copyright © 2016年 田中賢治. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let yellowColor = UIColor(red: 251.0/255.0, green: 215.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    let greenColor = UIColor(red: 210.0/255.0, green: 240.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    let blueColor = UIColor(red: 151.0/255.0, green: 224.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    var yellowCenter: CGPoint!
    var greenCenter: CGPoint!
    var blueCenter: CGPoint!
    
    let zoiSize = CGSize(width: 160, height: 160)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yellowCenter = view.center
        greenCenter = CGPoint(x: view.center.x + 180, y: view.center.y - 120)
        blueCenter = CGPoint(x: view.center.x - 180, y: view.center.y + 120)
    }

    // 一回目のみ縮小アニメーションを含むようにisFirst引数を設定
    func createZOILayer(center: CGPoint, size: CGSize, color: UIColor, isFirst: Bool) {
        let zoiLayer = ZOILayer(center: center, size: size, color: color)
        view.layer.addSublayer(zoiLayer)
        
        // 確実にメインスレッドで処理を実行するようにします
        dispatch_async(dispatch_get_main_queue()) {
            if isFirst {
                zoiLayer.startReductionScaleAnimation() {
                    zoiLayer.startExpansionScaleAnimation() { [weak self] in
                        guard let `self` = self else { return }
                        
                        // アニメーションの終わったlayerは破棄するようにします
                        zoiLayer.removeFromSuperlayer()
                        self.createZOILayer(center, size: size, color: color, isFirst: false)
                    }
                }
            } else {
                zoiLayer.startExpansionScaleAnimation() { [weak self] in
                    guard let `self` = self else { return }
                    
                    zoiLayer.removeFromSuperlayer()
                    self.createZOILayer(center, size: size, color: color, isFirst: false)
                }
            }
        }
        
    }
    
    @IBAction func tapButton(sender: AnyObject) {
        createZOILayer(yellowCenter, size: zoiSize, color: yellowColor, isFirst: true)
    }
    
    
    
    
    
    // ボタンタップ時のサンプル
    // storyboardのボタンのhiddenを切ると使えます。
    @IBAction func tapZOI(sender: AnyObject) {
        let zoiLayer = ZOILayer(center: view.center, size: CGSize(width: 50, height: 50), color: UIColor.redColor())
        view.layer.addSublayer(zoiLayer)
        
        zoiLayer.startReductionScaleAnimation() {
            zoiLayer.startExpansionScaleAnimation() {
                zoiLayer.removeFromSuperlayer()
            }
        }
    }
}

