//
//  ImageScrollView.swift
//  Soultime
//
//  Created by Oleksandr Bezpalchuk on 7/24/19.
//  Copyright © 2019 Oleksandr Bezpalchuk. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView {
    // MARK: - Public
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Cat.jpg"))
    var animationDuration: TimeInterval = 30.0
    var isLooped: Bool = true
    var isLoggingEnabled: Bool = true
    
    // MARK: - Private
    private let topLeftPoint = CGPoint.zero
    private lazy var topRightPoint = CGPoint(x: contentSize.width-bounds.width,
                                     y: 0)
    private lazy var bottomRightPoint = CGPoint(x: contentSize.width-bounds.width,
                                        y: contentSize.height-bounds.height-20)
    private lazy var bottomLeftPoint = CGPoint(x: 0,
                                       y: contentSize.height-bounds.height-20)

    private let bigFrame = CGSize(width: 1024, height: 1024)
    
    
    private var animator: UIViewPropertyAnimator?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        customInit()
    }
    
    private func customInit() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = false
        bounces = false
        isUserInteractionEnabled = false
        
        contentSize = bigFrame
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: -20), size: bigFrame)
        addSubview(imageView)
    }
    
    // MARK: - 
    func startAnimation() {
        setContentOffset(bottomRightPoint, animated: false)
        restart(from: imageView.center)
    }
    
    private func restart(from point: CGPoint) {
        var next: CGPoint?
        switch point {
        case topLeftPoint:
            next = [topRightPoint, bottomLeftPoint, bottomRightPoint].randomElement()
        case topRightPoint:
            next = [topLeftPoint, bottomLeftPoint, bottomRightPoint].randomElement()
        case bottomLeftPoint:
            next = [topRightPoint, topLeftPoint, bottomRightPoint].randomElement()
        case bottomRightPoint:
            next = [topRightPoint, bottomLeftPoint, topLeftPoint].randomElement()
        default:
            next = .zero
        }
        
        let randomCurve: AnimationCurve = [.easeIn, .easeOut, .easeInOut, .linear].randomElement() ?? .linear
        
        if isLoggingEnabled {
            printNextCorner(next)
            printNextCurve(randomCurve)
        }
        
        animator = UIViewPropertyAnimator(duration: animationDuration, curve: randomCurve) {
            self.contentOffset = next ?? .zero
        }
        
        animator?.startAnimation()
        
        if !self.isLooped { return }
        animator?.addCompletion { (position) in
            self.restart(from: self.contentOffset)
        }
    }
    
    private func printNextCorner(_ point: CGPoint?) {
        switch point {
        case topLeftPoint?: debugPrint("top Left")
        case topRightPoint?: debugPrint("top Right")
        case bottomLeftPoint?: debugPrint("bottom Left")
        case bottomRightPoint?: debugPrint("bottom Right")
        default:
            debugPrint("Unknown")
        }
    }
    private func printNextCurve(_ curve: AnimationCurve) {
        switch curve {
        case .easeInOut: debugPrint("easeInOut")
        case .easeIn: debugPrint("easeIn")
        case .easeOut: debugPrint("easeOut")
        case .linear: debugPrint("linear")
        @unknown default:
            debugPrint("Unknown")
            
        }
    }
}
