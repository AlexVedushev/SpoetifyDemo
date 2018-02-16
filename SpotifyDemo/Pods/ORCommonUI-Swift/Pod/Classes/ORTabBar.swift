//
//  ORTabBar.swift
//  Pods
//
//  Created by Maxim Soloviev on 26/04/2017.
//
//

import UIKit
import PureLayout

@available(iOS 9, *)
public protocol ORTabBarDelegate: class {
    
    // return 'true' if selection changing is possible, if return 'false' selection will not change
    func orTabBar(orTabBar: ORTabBar, didSelectItemWithIndex index: Int) -> Bool
}

open class ORTabBarItem: UIView {
    
    open func setSelected(_ selected: Bool) {
    }
}

@available(iOS 9, *)
fileprivate class ORTabBarStackView: UIStackView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        distribution = .fillEqually
        axis = .horizontal
        alignment = .fill
    }
}

@available(iOS 9, *)
open class ORTabBar: UIView {
    
    fileprivate var stackView = ORTabBarStackView()
    
    @IBInspectable open var tabBarItemWidth: CGFloat = 0
    
    var leadingConstraint = NSLayoutConstraint()
    var trailingConstraint = NSLayoutConstraint()
    var verticalAxisAlignConstraint = NSLayoutConstraint()
    open var spaceBetweenElementStackView: Int = 35
    
    open weak var delegate: ORTabBarDelegate?
    
    open var selectedIndex: Int?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if tabBarItemWidth > 0 {
            setTabBarItemWidth(width: tabBarItemWidth)
        } else {
            returnToDefaultConstraints()
        }
    }
    
    open func setItems(_ items: [ORTabBarItem]) {
        // remove all subviews if needed
        subviews.forEach { $0.removeFromSuperview() }
        stackView = ORTabBarStackView()
        
        addSubview(stackView)
        leadingConstraint = stackView.autoPinEdge(.left, to: .left, of: self)
        trailingConstraint = stackView.autoPinEdge(.right, to: .right, of: self)
        stackView.autoPinEdge(.top, to: .top, of: self)
        stackView.autoPinEdge(.bottom, to: .bottom, of: self)
        
        // add new items
        for index in 0 ..< items.count {
            let customButton = ORCustomContentButton(forAutoLayout: ())
            customButton.isExclusiveTouch = true
            customButton.tag = index
            stackView.addArrangedSubview(customButton)
            
            let item = items[index]
            item.isUserInteractionEnabled = false
            customButton.addSubview(item)
            item.autoPinEdgesToSuperviewEdges()
            
            item.setSelected(false)
            
            customButton.addTarget(self, action: #selector(touchUpInsideItem), for: .touchUpInside)
        }
    }
    
    open func selectItem(index: Int?) {
        if let selectedIndex = selectedIndex, stackView.arrangedSubviews.count > selectedIndex {
            let item = stackView.arrangedSubviews[selectedIndex].subviews.first as! ORTabBarItem
            item.setSelected(false)
        }
        
        selectedIndex = index
        
        if let selectedIndex = selectedIndex, stackView.arrangedSubviews.count > selectedIndex {
            let item = stackView.arrangedSubviews[selectedIndex].subviews.first as! ORTabBarItem
            item.setSelected(true)
        }
    }
    
    func touchUpInsideItem(_ sender: UIView) {
        let index = sender.tag
        
        if let delegate = delegate {
            let isChangeSelectionAllowed = delegate.orTabBar(orTabBar: self, didSelectItemWithIndex: index)
            
            if isChangeSelectionAllowed {
                selectItem(index: index)
            }
        } else {
            print("Warning: ORTabBarDelegate didn't set")
            selectItem(index: index)
        }
    }
    
    private func setTabBarItemWidth(width: CGFloat) {
        returnToDefaultConstraints()
        
        leadingConstraint.autoRemove()
        trailingConstraint.autoRemove()
        
        let widthConstraint = stackView.autoSetDimension(.width, toSize: width * CGFloat(stackView.arrangedSubviews.count) + CGFloat(spaceBetweenElementStackView * (stackView.arrangedSubviews.count - 1)))
        widthConstraint.identifier = "itemWidth"
        
        verticalAxisAlignConstraint = stackView.autoAlignAxis(.vertical, toSameAxisOf: self)
        
    }
    
    private func returnToDefaultConstraints() {
        if !leadingConstraint.isActive {
            stackView.setup()
            
            for constraint in stackView.constraints {
                if constraint.identifier == "itemWidth" {
                    constraint.autoRemove()
                }
            }
            
            verticalAxisAlignConstraint.autoRemove()
            
            leadingConstraint.autoInstall()
            trailingConstraint.autoInstall()
        }
    }
}
