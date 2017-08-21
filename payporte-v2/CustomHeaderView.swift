//
//  CustomHeaderView.swift
//  payporte-v2
//
//  Created by SimpuMind on 6/30/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import CLabsImageSlider

class CustomHeaderView: UIView, imageSliderDelegate {
    
    var baners = [String]()
    
    var banners: CLabsImageSlider = {
        let zc = CLabsImageSlider()
        return zc
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
    
    func fetchBanners(){
        
        Payporte.sharedInstance.fetchBanners { (banners, error, message, cursorCount) in
            
            if error != nil{
                Utilities.getBaseNotification(text: error!, type: .error)
                return
            }
            
            self.baners.removeAll()
            for i in 0 ..< (banners.count - 1){
                guard let img = banners[i].image_path else {return}
                self.baners.append(img)
            }
            
            
            self.banners.setUpView(imageSource: .Url(imageArray:self.baners,
                                                     placeHolderImage:UIImage(named:"placeholder")),slideType:.Automatic(timeIntervalinSeconds: 5),isArrowBtnEnabled: false)
            
            self.pageController.numberOfPages = self.baners.count
        }
    }
    
    func setUpView() {
        
        addSubview(banners)
        addSubview(pageController)
        
        banners.sliderDelegate = self
        banners.contentMode = .scaleAspectFill
        banners.clipsToBounds = true
        
        banners.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.left.equalTo(self.snp.left).offset(10)
            make.height.equalTo(150)
        }
        
        pageController.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.centerX.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        DispatchQueue.main.async {
            
            self.fetchBanners()
        }
    }
    
    func didMovedToIndex(index: Int) {
        self.pageController.currentPage = index
    }
    
    func ZCarouselShowingIndex(scrollview: ZCarousel, index: Int) {
        if scrollview == banners {
            print("Showing Image at index \(index)")
        }
    }
}
