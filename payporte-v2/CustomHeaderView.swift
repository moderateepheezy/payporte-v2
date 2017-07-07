//
//  CustomHeaderView.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import CLabsImageSlider

class CustomHeaderView: UIView, imageSliderDelegate  {
    
    let urlImages =    ["https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    
    let imgArray = ["03", "04", "05", "6"]
    
    var banners: CLabsImageSlider = {
        let zc = CLabsImageSlider()
        return zc
    }()
    
    var pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = primaryColor
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        
        addSubview(banners)
        addSubview(pageController)
        
        banners.sliderDelegate = self
        banners.contentMode = .scaleAspectFill
        banners.clipsToBounds = true
        pageController.numberOfPages = urlImages.count
        
        self.banners.setUpView(imageSource: .Url(imageArray:self.urlImages,placeHolderImage:UIImage(named:"placeholder")),slideType:.Automatic(timeIntervalinSeconds: 5),isArrowBtnEnabled: false)
        
        banners.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(2)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(230)
        }
        
        pageController.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.centerX.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
    }
    
    func didMovedToIndex(index: Int) {
        pageController.currentPage = index
    }
    
    func ZCarouselShowingIndex(scrollview: ZCarousel, index: Int) {
        if scrollview == banners {
            print("Showing Image at index \(index)")
        }
    }
}
