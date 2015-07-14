//
//  LKAlertController.swift
//  Pods
//
//  Created by Erik Sargent on 7/14/15.
//
//

import UIKit


public class LKAlertController {
    /** Internal alert controller to present to the user */
    internal var alertController: UIAlertController
    
    /** Title of the alert controller */
    internal var title: String? {
        get {
            return alertController.title
        }
        set {
            alertController.title = newValue
        }
    }
    
    /** Message of the alert controller */
    internal var message: String? {
        get {
            return alertController.title
        }
        set {
            alertController.message = newValue
        }
    }
    
    /**
    Initialize a new LKAlertController
    
    :params: style  .ActionSheet or .Alert
    */
    public init(style: UIAlertControllerStyle) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    /**
    Add a new button to the controller.
    
    :params: title  Title of the button
    :params: style  Style of the button (.Default, .Cancel, .Destructive)
    :params: handler  Closure to call when the button is pressed
    */
    public func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)? = nil) -> LKAlertController {
        var action = UIAlertAction(title: title, style: style, handler: { _ in })
        if let handler = handler {
            action = UIAlertAction(title: title, style: style, handler: handler)
        }
        
        alertController.addAction(action)
        
        return self
    }
    
    /**
    Present in the view
    */
    public func show() {
        show(animated: true, completion: nil)
    }
    
    /**
    Present in the view
    
    :params: animated  Whether to animate into the view or not
    */
    public func show(#animated: Bool) {
        show(animated: animated, completion: nil)
    }
    
    /**
    Present in the view
    
    :params: animated  Whether to animate into the view or not
    :params: completion  Closure to call when the button is pressed
    */
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
    
    /**
    Returns the instance of the UIAlertController
    */
    public func getAlertController() -> UIAlertController {
        return alertController
    }
}


public class Alert: LKAlertController {
    /**
    Create a new alert without a title or message
    */
    public init() {
        super.init(style: .Alert)
    }
    
    /**
    Create a new alert with a title
    
    :params: title  Title of the alert
    */
    public init(title: String?) {
        super.init(style: .Alert)
        self.title = title
    }
    
    /**
    Create a new alert with a message
    
    :params: message  Body of the alert
    */
    public init(message: String?) {
        super.init(style: .Alert)
        self.message = message
    }
    
    /**
    Create a new alert with a title and message
    
    :params: title  Title of the alert
    :params: message  Body of the alert
    */
    public init(title: String?, message: String?) {
        super.init(style: .Alert)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the alert. It will not have an action and will have the Cancel style
    
    :params: title  Title of the button
    */
    public func addAction(title: String) -> Alert {
        return addAction(title, style: .Cancel, handler: nil)
    }
    
    /**
    Add a new button to the alert.
    
    :params: title  Title of the button
    :params: style  Style of the button (.Default, .Cancel, .Destructive)
    :params: handler  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> Alert {
        return super.addAction(title, style: style, handler: handler) as! Alert
    }
}


public class ActionSheet: LKAlertController {
    /**
    Create a new action sheet without a title or message
    */
    public init() {
        super.init(style: .ActionSheet)
    }
    
    /**
    Create a new action sheet with a title
    
    :params: title  Title of the action sheet
    */
    public init(title: String?) {
        super.init(style: .ActionSheet)
        self.title = title
    }
    
    /**
    Create a new action sheet with a message
    
    :params: message  Body of the action sheet
    */
    public init(message: String?) {
        super.init(style: .ActionSheet)
        self.message = message
    }
    
    /**
    Create a new action sheet with a title and message
    
    :params: title  Title of the action sheet
    :params: message  Body of the action sheet
    */
    public init(title: String?, message: String?) {
        super.init(style: .ActionSheet)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the action sheet. It will not have an action and will have the Cancel style
    
    :params: title  Title of the button
    */
    public func addAction(title: String) -> ActionSheet {
        return addAction(title, style: .Cancel, handler: nil)
    }
    
    /**
    Add a new button to the action sheet.
    
    :params: title  Title of the button
    :params: style  Style of the button (.Default, .Cancel, .Destructive)
    :params: handler  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> ActionSheet {
        return super.addAction(title, style: style, handler: handler) as! ActionSheet
    }
}
