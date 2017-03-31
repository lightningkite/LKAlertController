//
//  LKAlertController.swift
//  Pods
//
//  Created by Erik Sargent on 7/14/15.
//
//

import UIKit


///Base class for creating an alert controller.
///Use Alert or ActionSheet instead
public class LKAlertController {
	///UIAlertActions callback
    public typealias actionHandler = (UIAlertAction!) -> Void
    
    ///Internal alert controller to present to the user
    internal var alertController: UIAlertController
	
	///Internal storage of view to present in
	internal var presentationSource: UIViewController? = nil
	
	///Internal storage of time to delay before presenting
	internal var delayTime: TimeInterval? = nil
	
    ///Internal static variable to store the override the show method for testing purposes
    internal static var alertTester: ((_ style: UIAlertControllerStyle, _ title: String?, _ message: String?, _ actions: [AnyObject], _ fields: [AnyObject]?) -> Void)? = nil
    
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

    ///Used internally to determine if the user has set the popover controller source for presenting
    internal var configuredPopoverController = false
	
	///Tint color for the controller
	internal var tintColor: UIColor? {
		didSet {
			//Set the tint color
			if let tint = tintColor {
				alertController.view.tintColor = tint
			}
		}
	}
    
    /**
     Required Textfield - Disables primary action if textfield is empty
    */
    internal var hasRequiredTextfield = false
    internal var alertPrimaryAction: UIAlertAction?
	
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
	@discardableResult
    public func addAction(_ title: String, style: UIAlertActionStyle, handler: actionHandler? = nil) -> LKAlertController {
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
	@discardableResult
    internal func addAction(_ title: String, style: UIAlertActionStyle, preferredAction: Bool = false, handler: actionHandler? = nil) -> LKAlertController {
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
                if(hasRequiredTextfield){
                    action.isEnabled = false
                    alertPrimaryAction = action
                }
            }
        }
        
        return self
    }
	
	///Set the view controller to present the alert in. By default this is the top controller in the window.
	@discardableResult
	public func presentIn(_ source: UIViewController) -> LKAlertController {
		presentationSource = source
		return self
	}
	
	///Delay the presentation of the controller.
	@discardableResult
	public func delay(_ time: TimeInterval) -> LKAlertController {
		delayTime = time
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
    public func show(animated: Bool) {
        show(animated: animated, completion: nil)
    }
    
    /**
    Present in the view
    
    - parameter animated:  Whether to animate into the view or not
    - parameter completion:  Closure to call when the button is pressed
    */
    public func show(animated: Bool, completion: (() -> Void)?) {
		//If a delay time has been set, delay the presentation of the alert by the delayTime
		if let time = delayTime {
			let dispatchTime = DispatchTime.now() + time
			DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
				self.show(animated: animated, completion: completion)
			}
			
			delayTime = nil
			return
		}
		
        //Override for testing
        if let alertTester = LKAlertController.alertTester {
            alertTester(alertController.preferredStyle, title, message, alertController.actions, alertController.textFields)
            LKAlertController.alertTester = nil
        }
        //Present the alert
        else if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            //Find the presented view controller
            var presentedController = viewController
            while presentedController.presentedViewController != nil && presentedController.presentedViewController?.isBeingDismissed == false {
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
			
			//Set the presentedController to the one the user has optionally assigned
			if let source = presentationSource {
				presentedController = source
			}
			
			DispatchQueue.main.async {
				presentedController.present(self.alertController, animated: animated, completion: completion)
			}
        }
    }
    
    ///Returns the instance of the UIAlertController
    public func getAlertController() -> UIAlertController {
        return alertController
    }
    
    ///Override the show function with a closure for using with your unit tests
    public class func overrideShowForTesting(_ callback: ((_ style: UIAlertControllerStyle, _ title: String?, _ message: String?, _ actions: [AnyObject], _ fields: [AnyObject]?) -> Void)?) {
        alertTester = callback
    }
}


///Alert controller
public class Alert: LKAlertController {
    ///Create a new alert without a title or message
    public init() {
        super.init(style: .alert)
    }
    
    /**
    Create a new alert with a title
    
    - parameter title:  Title of the alert
    */
    public init(title: String?) {
        super.init(style: .alert)
        self.title = title
    }
    
    /**
    Create a new alert with a message
    
    - parameter message:  Body of the alert
    */
    public init(message: String?) {
        super.init(style: .alert)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new alert with a title and message
    
    - parameter title:  Title of the alert
    - parameter message:  Body of the alert
    */
    public init(title: String?, message: String?) {
        super.init(style: .alert)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the alert. It will not have an action and will have the Cancel style
    
    - parameter title:  Title of the button
    */
	@discardableResult
    public func addAction(_ title: String) -> Alert {
        return addAction(title, style: .default, preferredAction: false, handler: nil)
    }
	
    /**
    Add a new button to the alert.
    
    - parameter title:  Title of the button
    - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
    - parameter handler:  Closure to call when the button is pressed
    */
	@discardableResult
    public override func addAction(_ title: String, style: UIAlertActionStyle, handler: actionHandler? = nil) -> Alert {
        return addAction(title, style: style, preferredAction: false, handler: handler)
    }
    
    /**
     Add a new action to the alert as the preferredAction .
     
     - parameter title:  Title of the button
     - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
     - parameter handler:  Closure to call when the button is pressed
     - parameter preferredAction: The preferred action for the user to take from an alert.
     */
	@discardableResult
    public override func addAction(_ title: String, style: UIAlertActionStyle, preferredAction: Bool, handler: actionHandler? = nil) -> Alert {
        return super.addAction(title, style: style, preferredAction: preferredAction, handler: handler) as! Alert
    }
    
    /**
    Add a text field to the controller
    
    - parameter textField:  textField to add to the alert (must be a var, not let)
    */
	@discardableResult
    public func addTextField( _ textField: inout UITextField, required: Bool = false) -> Alert {
		var field: UITextField?
		
        alertController.addTextField { [unowned textField] (tf: UITextField!) -> Void in
            tf.text = textField.text
            tf.placeholder = textField.placeholder
            tf.font = textField.font
            tf.textColor = textField.textColor
            tf.isSecureTextEntry = textField.isSecureTextEntry
            tf.keyboardType = textField.keyboardType
            tf.autocapitalizationType = textField.autocapitalizationType
            tf.autocorrectionType = textField.autocorrectionType
            
            field = tf
        }
        
        if(required) {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: field, queue: OperationQueue.main) { (notification) in
                if let actionButton = self.alertPrimaryAction {
                    actionButton.isEnabled = field?.text?.isEmpty == false
                }
            }
            self.hasRequiredTextfield = true
        }
        
		if let field = field {
			textField = field
		}
        
        return self
    }
	
	///Set the view controller to present the alert in. By default this is the top controller in the window.
	@discardableResult
	public override func presentIn(_ source: UIViewController) -> Alert {
		return super.presentIn(source) as! Alert
	}
	
	///Delay the presentation of the controller.
	@discardableResult
	public override func delay(_ time: TimeInterval) -> Alert {
		return super.delay(time) as! Alert
	}
	
	///Set the tint color for the alert
	@discardableResult
	public func tint(_ color: UIColor) -> Alert {
		tintColor = color
		return self
	}
    
    ///Shortcut method for adding an Okay button and showing the alert
    public func showOkay() {
        super.addAction("Okay", style: .cancel, preferredAction: false, handler: nil)
        show()
    }
}


///Action sheet controller
public class ActionSheet: LKAlertController {
    ///Create a new action sheet without a title or message
    public init() {
        super.init(style: .actionSheet)
    }
    
    /**
    Create a new action sheet with a title
    
    - parameter title:  Title of the action sheet
    */
    public init(title: String?) {
        super.init(style: .actionSheet)
        self.title = title
    }
    
    /**
    Create a new action sheet with a message
    
    - parameter message:  Body of the action sheet
    */
    public init(message: String?) {
        super.init(style: .actionSheet)
        self.message = message
        self.title = message == nil ? nil : ""
    }
    
    /**
    Create a new action sheet with a title and message
    
    - parameter title:  Title of the action sheet
    - parameter message:  Body of the action sheet
    */
    public init(title: String?, message: String?) {
        super.init(style: .actionSheet)
        self.title = title
        self.message = message
    }
    
    /**
    Add a new button to the action sheet. It will not have an action and will have the Cancel style
    
    - parameter title:  Title of the button
    */
	@discardableResult
    public func addAction(_ title: String) -> ActionSheet {
        return addAction(title, style: .cancel, handler: nil)
    }
    
    /**
    Add a new button to the action sheet.
    
    - parameter title:  Title of the button
    - parameter style:  Style of the button (.Default, .Cancel, .Destructive)
    - parameter handler:  Closure to call when the button is pressed
    */
	@discardableResult
    public override func addAction(_ title: String, style: UIAlertActionStyle, handler: actionHandler? = nil) -> ActionSheet {
        return super.addAction(title, style: style, preferredAction: false, handler: handler) as! ActionSheet
    }
	
	///Set the view controller to present the alert in. By default this is the top controller in the window.
	@discardableResult
	public override func presentIn(_ source: UIViewController) -> ActionSheet {
		return super.presentIn(source) as! ActionSheet
	}
	
	//Delay the presentation of the controller.
	@discardableResult
	open override func delay(_ time: TimeInterval) -> ActionSheet {
		return super.delay(time) as! ActionSheet
	}
	
	///Set the tint color for the action sheet
	public func tint(_ color: UIColor) -> ActionSheet {
		tintColor = color
		return self
	}
    
    /**
    Set the presenting bar button item. Used for presenting the action sheet on iPad.
    If this isn't set, it will default to the presenting view on iPad.
    
    - parameter item:  UIBarButtonItem that the action sheet will present from
    */
	@discardableResult
    public func setBarButtonItem(_ item: UIBarButtonItem) -> ActionSheet {
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
	@discardableResult
    public func setPresentingSource(_ source: UIView) -> ActionSheet {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = source
            popoverController.sourceRect = source.bounds
        }
        super.configuredPopoverController = true
        
        return self
    }
}
