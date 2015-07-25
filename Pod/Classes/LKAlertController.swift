//
//  LKAlertController.swift
//  Pods
//
//  Created by Erik Sargent on 7/14/15.
//
//

import UIKit


/**
Base class for creating an alert controller.
Use Alert or ActionSheet instead
*/
public class LKAlertController {
    /** Internal alert controller to present to the user */
    internal var alertController: UIAlertController
    
    /** Internal static variable to store the override the show method for testing purposes */
    internal static var alertTester: ((style: UIAlertControllerStyle, title: String?, message: String?, actions: [AnyObject]) -> Void)? = nil
    
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
            return alertController.message
        }
        set {
            alertController.message = newValue
        }
    }

    /** Used internally to determine if the user has set the popover controller source for presenting */
    internal var configuredPopoverController = false
    
    /**
    Initialize a new LKAlertController
    
    :param: style  .ActionSheet or .Alert
    */
    public init(style: UIAlertControllerStyle) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    /**
    Add a text field to the controller
    
    :param: placeholder  Placeholder text for text field
    :param: secureText  Secure text entry for text field
    */
    public func addTextField(placeholder: String?, secureText: Bool?) {
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            if let placeholder = placeholder {
                textField.placeholder = placeholder
            }
            if let secureText = secureText {
                textField.secureTextEntry = true
            }
        }
    }
    
    /**
    Add a new button to the controller.
    
    :param: title  Title of the button
    :param: style  Style of the button (.Default, .Cancel, .Destructive)
    :param: handler  Closure to call when the button is pressed
    */
    public func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)? = nil) -> LKAlertController {
        var action: UIAlertAction
        if let handler = handler {
            action = UIAlertAction(title: title, style: style, handler: handler)
        } else {
            action = UIAlertAction(title: title, style: style, handler: { _ in })
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
    
    :param: animated  Whether to animate into the view or not
    */
    public func show(#animated: Bool) {
        show(animated: animated, completion: nil)
    }
    
    /**
    Present in the view
    
    :param: animated  Whether to animate into the view or not
    :param: completion  Closure to call when the button is pressed
    */
    public func show(#animated: Bool, completion: (() -> Void)?) {
        //Override for testing
        if let alertTester = LKAlertController.alertTester {
            alertTester(style: alertController.preferredStyle, title: title, message: message, actions: alertController.actions)
            LKAlertController.alertTester = nil
        }
        //Present the alert
        else if let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            //Find the presented view controller
            var presentedController = viewController
            while (presentedController.presentedViewController != nil) {
                presentedController = presentedController.presentedViewController!
            }
            
            //If the user has not configured the popover controller source on ipad then set it to the presenting view
            if self is ActionSheet && !configuredPopoverController,
                let popoverController = alertController.popoverPresentationController {
                    
                    var topController = presentedController
                    while (topController.childViewControllers.last != nil) {
                        topController = topController.childViewControllers.last as! UIViewController
                    }
                    
                    popoverController.sourceView = topController.view
                    popoverController.sourceRect = topController.view.bounds
            }
            
            presentedController.presentViewController(alertController, animated: animated, completion: completion)
        }
    }
    
    /**
    Returns the instance of the UIAlertController
    */
    public func getAlertController() -> UIAlertController {
        return alertController
    }
    
    /**
    Override the show function with a closure for using with your unit tests
    */
    public class func overrideShowForTesting(callback: ((style: UIAlertControllerStyle, title: String?, message: String?, actions: [AnyObject]) -> Void)?) {
        alertTester = callback
    }
}


/**
Alert controller
*/
public class Alert: LKAlertController {
    /**
    Create a new alert without a title or message
    */
    public init() {
        super.init(style: .Alert)
    }
    
    /**
    Create a new alert with a title
    
    :param: title  Title of the alert
    */
    public init(title: String?) {
        super.init(style: .Alert)
        self.title = title
    }
    
    /**
    Create a new alert with a message
    
    :param: message  Body of the alert
    */
    public init(message: String?) {
        super.init(style: .Alert)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new alert with a title and message
    
    :param: title  Title of the alert
    :param: message  Body of the alert
    */
    public init(title: String?, message: String?) {
        super.init(style: .Alert)
        self.title = title
        self.message = message
    }
    
    /**
    Add a text field to the controller. It will not have any placeholder text nor secure text entry
    */
    public func addTextField() {
        super.addTextField(nil, secureText: nil)
    }
    
    /**
    Add a text field with placeholder text to the controller
    
    :param: placeholder  Placeholder text for text field
    */
    public func addTextField(placeholder: String) {
        super.addTextField(placeholder, secureText: nil)
    }
    
    /**
    Add a text field with secure text entry to the controller
    
    :param: secureText  Secure text entry for text field
    */
    public func addTextField(secureText: Bool) {
        super.addTextField(nil, secureText: secureText)
    }
    
    /**
    Add a new button to the alert. It will not have an action and will have the Cancel style
    
    :param: title  Title of the button
    */
    public func addAction(title: String) -> Alert {
        return addAction(title, style: .Cancel, handler: nil)
    }
    
    /**
    Add a new button to the alert.
    
    :param: title  Title of the button
    :param: style  Style of the button (.Default, .Cancel, .Destructive)
    :param: handler  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> Alert {
        return super.addAction(title, style: style, handler: handler) as! Alert
    }
    
    /**
    Shortcut method for adding an Okay button and showing the alert
    */
    public func showOkay() {
        super.addAction("Okay", style: .Cancel, handler: nil)
        show()
    }
}


/**
Action sheet controller
*/
public class ActionSheet: LKAlertController {
    /**
    Create a new action sheet without a title or message
    */
    public init() {
        super.init(style: .ActionSheet)
    }
    
    /**
    Create a new action sheet with a title
    
    :param: title  Title of the action sheet
    */
    public init(title: String?) {
        super.init(style: .ActionSheet)
        self.title = title
    }
    
    /**
    Create a new action sheet with a message
    
    :param: message  Body of the action sheet
    */
    public init(message: String?) {
        super.init(style: .ActionSheet)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new action sheet with a title and message
    
    :param: title  Title of the action sheet
    :param: message  Body of the action sheet
    */
    public init(title: String?, message: String?) {
        super.init(style: .ActionSheet)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the action sheet. It will not have an action and will have the Cancel style
    
    :param: title  Title of the button
    */
    public func addAction(title: String) -> ActionSheet {
        return addAction(title, style: .Cancel, handler: nil)
    }
    
    /**
    Add a new button to the action sheet.
    
    :param: title  Title of the button
    :param: style  Style of the button (.Default, .Cancel, .Destructive)
    :param: handler  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction!) -> Void)?) -> ActionSheet {
        return super.addAction(title, style: style, handler: handler) as! ActionSheet
    }
    
    /**
    Set the presenting bar button item. Used for presenting the action sheet on iPad.
    If this isn't set, it will default to the presenting view on iPad.
    
    :param: item  UIBarButtonItem that the action sheet will present from
    */
    public func setBarButtonItem(item: UIBarButtonItem) -> ActionSheet {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = item
        }
        super.configuredPopoverController = true
        
        return self
    }
    
    /**
    Set the presenting source view. Used for presenting the action sheet on iPad.
    If this isn't set, it will default to the presenting view on iPad.
    
    :param: source  The view the action sheet will present from
    */
    public func setPresentingSource(source: UIView) -> ActionSheet {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = source
            popoverController.sourceRect = source.bounds
        }
        super.configuredPopoverController = true
        
        return self
    }
}
