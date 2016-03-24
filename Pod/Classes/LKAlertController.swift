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
    public typealias actionHandler = UIAlertAction! -> Void
    
    ///Internal alert controller to present to the user
    internal var alertController: UIAlertController
    
    ///Internal static variable to store the override the show method for testing purposes
    internal static var alertTester: ((style: UIAlertControllerStyle, title: String?, message: String?, actions: [AnyObject], fields: [AnyObject]?) -> Void)? = nil
    
    ///Title of the alert controller
    internal var title: String? {
        get {
            return alertController.title
        }
        set {
            alertController.title = newValue
        }
    }
    
    ///Message of the alert controller
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
    
    - parameter style:  .ActionSheet or .Alert
    */
    public init(style: UIAlertControllerStyle) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    
    /**
     Add a new button to the controller.
     
     - parameter title:  Title of the button
     - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
     - parameter handler:  Closure to call when the button is pressed
     */
    public func addAction(title: String, style: UIAlertActionStyle, handler: actionHandler? = nil) -> LKAlertController {
        addAction(title, style: style, preferredAction: false, handler: handler)
        
        return self
    }
    
    
    /**
    Add a new button to the controller.
    
    - parameter title:  Title of the button
    - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
    - parameter preferredAction: Whether or not this action is the default action when return is pressed on a hardware keyboard
    - parameter handler:  Closure to call when the button is pressed
    */
    internal func addAction(title: String, style: UIAlertActionStyle, preferredAction: Bool = false, handler: actionHandler? = nil) -> LKAlertController {
        var action: UIAlertAction
        if let handler = handler {
            action = UIAlertAction(title: title, style: style, handler: handler)
        } else {
            action = UIAlertAction(title: title, style: style, handler: { _ in })
        }
        
        alertController.addAction(action)
        
        if #available(iOS 9.0, *) {
            if preferredAction {
                alertController.preferredAction = action
            }
        }
        
        return self
    }
    
    ///Present in the view
    public func show() {
        show(animated: true, completion: nil)
    }
    
    /**
    Present in the view
    
    - parameter animated:  Whether to animate into the view or not
    */
    public func show(animated animated: Bool) {
        show(animated: animated, completion: nil)
    }
    
    /**
    Present in the view
    
    - parameter animated:  Whether to animate into the view or not
    - parameter completion:  Closure to call when the button is pressed
    */
    public func show(animated animated: Bool, completion: (() -> Void)?) {
        //Override for testing
        if let alertTester = LKAlertController.alertTester {
            alertTester(style: alertController.preferredStyle, title: title, message: message, actions: alertController.actions, fields: alertController.textFields)
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
                        topController = topController.childViewControllers.last!
                    }
                    
                    popoverController.sourceView = topController.view
                    popoverController.sourceRect = topController.view.bounds
            }
            
            presentedController.presentViewController(alertController, animated: animated, completion: completion)
        }
    }
    
    ///Returns the instance of the UIAlertController
    public func getAlertController() -> UIAlertController {
        return alertController
    }
    
    ///Override the show function with a closure for using with your unit tests
    public class func overrideShowForTesting(callback: ((style: UIAlertControllerStyle, title: String?, message: String?, actions: [AnyObject], fields: [AnyObject]?) -> Void)?) {
        alertTester = callback
    }
}


///Alert controller
public class Alert: LKAlertController {
    ///Create a new alert without a title or message
    public init() {
        super.init(style: .Alert)
    }
    
    /**
    Create a new alert with a title
    
    - parameter title:  Title of the alert
    */
    public init(title: String?) {
        super.init(style: .Alert)
        self.title = title
    }
    
    /**
    Create a new alert with a message
    
    - parameter message:  Body of the alert
    */
    public init(message: String?) {
        super.init(style: .Alert)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new alert with a title and message
    
    - parameter title:  Title of the alert
    - parameter message:  Body of the alert
    */
    public init(title: String?, message: String?) {
        super.init(style: .Alert)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the alert. It will not have an action and will have the Cancel style
    
    - parameter title:  Title of the button
    */
    public func addAction(title: String) -> Alert {
        return addAction(title, style: .Cancel, preferredAction: false, handler: nil)
    }
    
    /**
    Add a new button to the alert.
    
    - parameter title:  Title of the button
    - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
    - parameter handler:  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: actionHandler?) -> Alert {
        return addAction(title, style: style, preferredAction: false, handler: handler)
    }
    
    /**
     Add a new action to the alert as the preferredAction .
     
     - parameter title:  Title of the button
     - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
     - parameter handler:  Closure to call when the button is pressed
     - parameter preferredAction: The preferred action for the user to take from an alert.
     */
    public override func addAction(title: String, style: UIAlertActionStyle, preferredAction: Bool, handler: actionHandler?) -> Alert {
        return super.addAction(title, style: style, preferredAction: preferredAction, handler: handler) as! Alert
    }
    
    /**
    Add a text field to the controller
    
    - parameter textField:  textField to add to the alert (must be a var, not let)
    */
    public func addTextField(inout textField: UITextField) -> Alert {
        alertController.addTextFieldWithConfigurationHandler { (tf: UITextField!) -> Void in
            tf.text = textField.text
            tf.placeholder = textField.placeholder
            tf.font = textField.font
            tf.textColor = textField.textColor
            tf.secureTextEntry = textField.secureTextEntry
            tf.keyboardType = textField.keyboardType
            tf.autocapitalizationType = textField.autocapitalizationType
            tf.autocorrectionType = textField.autocorrectionType
            
            textField = tf
        }
        
        return self
    }
    
    ///Shortcut method for adding an Okay button and showing the alert
    public func showOkay() {
        super.addAction("Okay", style: .Cancel, handler: nil, preferredAction: false)
        show()
    }
}


///Action sheet controller
public class ActionSheet: LKAlertController {
    ///Create a new action sheet without a title or message
    public init() {
        super.init(style: .ActionSheet)
    }
    
    /**
    Create a new action sheet with a title
    
    - parameter title:  Title of the action sheet
    */
    public init(title: String?) {
        super.init(style: .ActionSheet)
        self.title = title
    }
    
    /**
    Create a new action sheet with a message
    
    - parameter message:  Body of the action sheet
    */
    public init(message: String?) {
        super.init(style: .ActionSheet)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new action sheet with a title and message
    
    - parameter title:  Title of the action sheet
    - parameter message:  Body of the action sheet
    */
    public init(title: String?, message: String?) {
        super.init(style: .ActionSheet)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the action sheet. It will not have an action and will have the Cancel style
    
    - parameter title:  Title of the button
    */
    public func addAction(title: String) -> ActionSheet {
        return addAction(title, style: .Cancel, handler: nil)
    }
    
    /**
    Add a new button to the action sheet.
    
    - parameter title:  Title of the button
    - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
    - parameter handler:  Closure to call when the button is pressed
    */
    public override func addAction(title: String, style: UIAlertActionStyle, handler: actionHandler?) -> ActionSheet {
        return super.addAction(title, style: style, preferredAction: false, handler: handler) as! ActionSheet
    }
    
    /**
    Set the presenting bar button item. Used for presenting the action sheet on iPad.
    If this isn't set, it will default to the presenting view on iPad.
    
    - parameter item:  UIBarButtonItem that the action sheet will present from
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
    
    - parameter source:  The view the action sheet will present from
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
