//
//  LKAlertController.swift
//  Pods
//
//  Created by Erik Sargent on 7/14/15.
//
//

import UIKit


public class LKAlertController {
    internal var alertController: UIAlertController
    
    internal var title: String? {
        get {
            return alertController.title
        }
        set {
            alertController.title = newValue
        }
    }
    
    internal var message: String? {
        get {
            return alertController.title
        }
        set {
            alertController.message = newValue
        }
    }
    
    public init(style: UIAlertControllerStyle) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    public func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)? = nil) -> LKAlertController {
        var action = UIAlertAction(title: title, style: style, handler: { _ in })
        if let handler = handler {
            action = UIAlertAction(title: title, style: style, handler: handler)
        }
        
        alertController.addAction(action)
        
        return self
    }
    
    public func show() {
        show(animated: true, completion: nil)
    }
    
    public func show(#animated: Bool) {
        show(animated: animated, completion: nil)
    }
    
    public func show(#animated: Bool, completion: (() -> Void)?) {
        if let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            //Find the presented view controller
            var topController = viewController
            while (topController.presentedViewController != nil) {
                topController = topController.presentedViewController!
            }
            
            topController.presentViewController(alertController, animated: animated, completion: completion)
        }
    }
    
    public func getAlertController() -> UIAlertController {
        return alertController
    }
}


public class Alert: LKAlertController {
    public init(title: String?) {
        super.init(style: .Alert)
        self.title = title
    }
    
    public init(message: String?) {
        super.init(style: .Alert)
        self.message = message
    }
    
    public init(title: String?, message: String?) {
        super.init(style: .Alert)
        self.title = title
        self.message = message
    }
    
    public func addAction(title: String) -> Alert {
        return addAction(title, style: .Default, handler: nil)
    }
    
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> Alert {
        return super.addAction(title, style: .Default, handler: handler) as! Alert
    }
}


public class ActionSheet: LKAlertController {
    public init(title: String?) {
        super.init(style: .ActionSheet)
        self.title = title
    }
    
    public init(message: String?) {
        super.init(style: .ActionSheet)
        self.message = message
    }
    
    public init(title: String?, message: String?) {
        super.init(style: .ActionSheet)
        self.title = title
        self.message = message
    }
    
    public func addAction(title: String) -> ActionSheet {
        return addAction(title, style: .Default, handler: nil)
    }
    
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> ActionSheet {
        return super.addAction(title, style: .Default, handler: handler) as! ActionSheet
    }
}
