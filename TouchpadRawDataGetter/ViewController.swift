//
//  ViewController.swift
//  TouchpadRawDataGetter
//
//  Created by Takuto Nakamura on 2019/04/09.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Cocoa
import M5MultitouchSupport

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!
    
    var manager: M5MultitouchManager! = nil
    var listener: M5MultitouchListener! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = M5MultitouchManager.shared()
        listener = manager.addListener(callback: { [weak self] (event) in
            if let e = event, let touches = e.touches as NSArray as? [M5MultitouchTouch] {
                DispatchQueue.main.async {
                    self?.process(touches)
                }
            }
        })
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        listener.listening = false
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    func process(_ touches: [M5MultitouchTouch]) {
        var currentInfo: String = "["
        currentInfo += touches.map({ (touch) -> String in
            return String(format: "ID: %d, state: %@, Position(x, y) = (%0.4f, %0.4f), Velocity(x, y) = (%+0.4f, %+0.4f), Size: %0.4f, Axis(major, minor) = (%0.4f, %0.4f), Angle: %0.4f",
                          touch.identifier,
                          stateString(touch.state),
                          touch.posX,
                          touch.posY,
                          touch.velX,
                          touch.velY,
                          touch.size,
                          touch.majorAxis,
                          touch.minorAxis,
                          touch.angle)
        }).joined(separator: "\n ")
        currentInfo += "]"
        textField.stringValue = currentInfo
    }
    
    func stateString(_ state: M5MultitouchTouchState) -> String {
        switch state {
        case .notTouching: return "notTouching"
        case .starting: return "starting"
        case .hovering: return "hovering"
        case .making: return "making"
        case .touching: return "touching"
        case .breaking: return "breaking"
        case .lingering: return "lingering"
        case .leaving: return "leaving"
        default: return "unknown"
        }
    }
    
}

