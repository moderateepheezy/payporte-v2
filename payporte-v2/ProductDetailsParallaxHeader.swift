//
//  ProductDetailsParallaxHeader.swift
//  payporte-v2
//
//  Created by SimpuMind on 7/31/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SwiftImageCarousel

public class ProductDetailsParallaxHeader: UIView, SwiftImageCarouselVCDelegate {
    
    
    var product: Product?{
        didSet{
            setUpView()
            guard let productImages = product?.productImages else {return}
            self.setupCarousel(array: productImages)
            
        }
    }
    
    var productDetailsVc: ProductBuyDetailsVC?
    
    var imagesArray = [String]()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        addSubview(containerView)
        
        containerView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top)
            make.left.right.equalTo(self)
            make.height.equalTo(self.frame.height)
        }
        
    }
    
    func setupCarousel(array: [String]){
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle(for: SwiftImageCarouselVC.self))
        let vc = storyboard.instantiateInitialViewController() as! SwiftImageCarouselVC
        vc.contentImageURLs = array
        
        vc.noImage = #imageLiteral(resourceName: "placeholder")
        vc.contentMode = .scaleAspectFit
        vc.swiftImageCarouselVCDelegate = self
        vc.escapeFirstPageControlDefaultFrame = true
        vc.willMove(toParentViewController: productDetailsVc)
        containerView.addSubview(vc.view)
        
        vc.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        
        productDetailsVc?.addChildViewController(vc)
        vc.didMove(toParentViewController: productDetailsVc)
    }
}
