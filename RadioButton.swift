//
//  RadioButton.swift
//  CustomControl
//
//  Created by aney on 2018. 1. 6..
//  Copyright © 2018년 Ted Kim. All rights reserved.
//

import UIKit

@IBDesignable class RadioButton: UIControl {
  @IBInspectable var lineWidth: CGFloat = 1.0
  @IBInspectable var iconSize: CGFloat = 32.0
  
  private var shapeLayer: CAShapeLayer!
  private var button: UIButton!
  
  var checkedHandler: (() -> ())?
  var unCheckedHandler: (() -> ())?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if shapeLayer == nil {
      shapeLayer = CAShapeLayer()
      shapeLayer.anchorPoint = .zero
      layer.addSublayer(shapeLayer)
      
      button = UIButton(type: .system)
      button.frame = bounds
      addSubview(button)
    }
    
    shapeLayer.bounds = bounds
    applySettings()
  }
  
  func applySettings() {
    if lineWidth <= 0 {
      shapeLayer.strokeColor = UIColor.clear.cgColor
    } else {
      shapeLayer.strokeColor = tintColor.cgColor
      shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.lineWidth = lineWidth
      
      let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
      let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
      
      shapeLayer.path = path.cgPath
      
      button.setImage(nil, for: .normal)
      
      button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
  }
  
  private func renderCircle() -> UIImage {
    let drawRect = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
    let renderer = UIGraphicsImageRenderer(bounds: drawRect)
    
    return renderer.image { ctx in
      let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
      tintColor.set()
      path.fill()
    }
  }
  
  @objc private func buttonTapped() {
    if isSelected {
      isSelected = false
      button.setImage(nil, for: .normal)
      
      if let unCheckedHandler = unCheckedHandler {
        unCheckedHandler()
      }
    } else {
      isSelected = true
      button.setImage(renderCircle(), for: .normal)
      
      if let checkedHandler = checkedHandler {
        checkedHandler()
      }
    }
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    applySettings()
  }

}
