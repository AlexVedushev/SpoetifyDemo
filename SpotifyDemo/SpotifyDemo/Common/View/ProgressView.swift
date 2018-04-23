//
//  ProgressView.swift
//  Instructrr
//
//  Created by Alexey Vedushev on 19/03/2018.
//  Copyright © 2018 Omega-R. All rights reserved.
//

import UIKit


protocol ProgresslViewDelegate: class {
    func progressDidChange(progress: Float)
}

protocol ProgressControl {
    func setCurrentProgress(_ progress: Float)
}

@IBDesignable
class ProgressView: UIView, ProgressControl {
    
    @IBInspectable var progress: Float = 0.5 {
        didSet {
            progress = min(1, progress)
            updateProgress(progress: progress)
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.white {
        didSet {
            progressLayer?.fillColor = fillColor.cgColor
        }
    }
    
    
    @IBInspectable var placeholderColor: UIColor = UIColor.white.withAlphaComponent(0.2) {
        didSet {
            updateProgress(progress: progress)
        }
    }
    
    @IBInspectable var progressLineHeight: CGFloat = 4 {
        didSet {
            updateProgress(progress: progress)
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = 4 {
        didSet {
            updateProgress(progress: progress)
        }
    }
    
    var progressLayer: CAShapeLayer?
    var placeholderLayer: CAShapeLayer?
    
    weak var delegate: ProgresslViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        backgroundColor = UIColor.clear
        updateProgress(progress: progress)
    }
    
    //MARK: - ProgressControl
    
    func setCurrentProgress(_ progress: Float) {
        self.progress = progress
    }
    
    //MARK: - Touches methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let x = touches.first?.location(in: self).x else {return}
        let progress = x / bounds.width
        self.progress = Float(progress)
        delegate?.progressDidChange(progress: self.progress)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let x = touches.first?.location(in: self).x else {return}
        let progress = x / bounds.width
        self.progress = Float(progress)
        delegate?.progressDidChange(progress: self.progress)
    }
    
    fileprivate func prepare() {
        clipsToBounds = true
        backgroundColor = UIColor.clear
        updateProgress(progress: progress)
    }
    
    // MARK: - Draw helpers
    
    fileprivate func updateProgress(progress: Float) {
        if placeholderLayer == nil {
            placeholderLayer = makeShapeLayer(fillColor: placeholderColor)
            layer.mask = placeholderLayer
            layer.addSublayer(placeholderLayer!)
        }
        let y: CGFloat = (bounds.height - lineHeight) / 2
        let origin = CGPoint(x: 0, y: y)
        let placeholderSize = CGSize(width: bounds.width, height: lineHeight)
        let placeholdeRect = CGRect(origin: origin, size: placeholderSize)
        placeholderLayer?.fillColor = placeholderColor.cgColor
        placeholderLayer?.path = UIBezierPath(roundedRect: placeholdeRect, cornerRadius: CGFloat.leastNonzeroMagnitude).cgPath
        
        if progressLayer == nil {
            progressLayer = makeShapeLayer(fillColor: fillColor)
            layer.addSublayer(progressLayer!)
        }
        if progress == 0 {
            progressLayer?.path = nil  // just hide
        } else {
            let progressLineY: CGFloat = (bounds.height - progressLineHeight) / 2
            let progressLineOrigin = CGPoint(x: 0, y: progressLineY)
            let rect = CGRect(origin: progressLineOrigin, size: CGSize(width: bounds.width * CGFloat(progress), height: progressLineHeight))
            progressLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat.leastNonzeroMagnitude).cgPath
        }
    }
    
    fileprivate func makeShapeLayer(fillColor: UIColor) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.fillColor = fillColor.cgColor
        return shape
    }
}

