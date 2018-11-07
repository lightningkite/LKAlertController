//
//  LKAlertControllerTests.swift
//  LKAlertController
//
//  Created by Erik Sargent on 7/14/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import XCTest

import LKAlertController


class LKAlertControllerTests: XCTestCase {
    
    func testCreateAlertControllerAlert() {
        let controller = LKAlertController(style: .alert).getAlertController()
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The style was not initialized correctly")
    }
    
    func testCreateAlertControllerActionSheet() {
        let controller = LKAlertController(style: .actionSheet).getAlertController()
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The style was not initialized correctly")
    }
    
    func testAddAction() {
        let handler: (UIAlertAction?) -> Void = { (UIAlertAction) -> Void in
            print("TESTING")
        }
        
        let controller = LKAlertController(style: .alert).addAction("Okay", style: .default, handler: handler).getAlertController()
        XCTAssertEqual(controller.actions.count, 1, "The number of actions was incorrect")
        
        if let action = controller.actions.first {
            XCTAssertEqual(action.title, "Okay", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertAction.Style.default, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the action")
        }
    }
    
    func testAddMultipleActions() {
        let handler: (UIAlertAction?) -> Void = { (UIAlertAction) -> Void in
            print("TESTING")
        }
        
        let controller = LKAlertController(style: .alert)
            .addAction("Okay", style: .default, handler: handler).addAction("Cancel", style: .cancel, handler: handler)
            .getAlertController()
        
        XCTAssertEqual(controller.actions.count, 2, "The number of actions was incorrect")
        
        if let action = controller.actions.first {
            XCTAssertEqual(action.title, "Okay", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertAction.Style.default, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the first action")
        }
        
        if let action = controller.actions.last {
            XCTAssertEqual(action.title, "Cancel", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertAction.Style.cancel, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the last action")
        }
    }
    
    func testOverrideShowForTesting() {
        let expectation = self.expectation(description: "Show override")
        
        let theStyle = UIAlertController.Style.alert
        let theTitle = "Alert Title"
        let theMessage = "Alert Message"
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(style, theStyle, "The style was incorrect")
            if let title = title {
                XCTAssertEqual(title, theTitle, "The title was incorrect")
            }
            else {
                XCTFail("The title was nil")
            }
            if let message = message {
                XCTAssertEqual(message, theMessage, "The message was incorrect")
            }
            else {
                XCTFail("The message was nil")
            }
            
            expectation.fulfill()
        }
        
        Alert(title: theTitle, message: theMessage).show()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testShow() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 0, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.alert, "Incorrect Style of the alert")
            
            expectation.fulfill()
        }
        
        LKAlertController(style: .alert).show()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    func testShowAnimated() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 0, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.alert, "Incorrect Style of the alert")
            
            expectation.fulfill()
        }
        
        LKAlertController(style: .alert).show(animated: true)
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testShowAnimatedCompletion() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 0, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.alert, "Incorrect Style of the alert")
            
            expectation.fulfill()
        }
        
        LKAlertController(style: .alert).show(animated: true, completion: nil)
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
	
	func testDelay() {
		let expectation = self.expectation(description: "Delay testing")
		
		var startTime = Date()
		
		LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
			
			let endTime = Date()
			let delayTime = Int(round(endTime.timeIntervalSince(startTime)))
			
			XCTAssertEqual(delayTime, 5)
			
			expectation.fulfill()
		}
		
		startTime = Date()
		
		Alert(title: "Title", message: "Message").addAction("Cancel").delay(5).show()
		
		waitForExpectations(timeout: 6, handler: nil)
	}
}


class AlertTests: XCTestCase {
    func testInit() {
        let controller = Alert().getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithTitle() {
        let controller = Alert(title: "the title").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitle() {
        let controller = Alert(title: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithMessage() {
        let controller = Alert(message: "the message").getAlertController()
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertNotNil(controller.title, "The title was nil")
        if controller.title != nil {
            XCTAssertEqual(controller.title!, "", "The title was not blank")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithNilMessage() {
        let controller = Alert(message: nil).getAlertController()
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndMessage() {
        let controller = Alert(title: "the title", message: "the message").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndMessage() {
        let controller = Alert(title: nil, message: "the message").getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndNilMessage() {
        let controller = Alert(title: "the title", message: nil).getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let _ = controller.title {
            XCTAssertEqual(controller.title!, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndNilMessage() {
        let controller = Alert(title: nil, message: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.alert, "The controller type was incorrect")
    }
    
    func testShow() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 1, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.alert, "Incorrect Style of the alert")
            
            if let button = actions.first as? UIAlertAction {
                XCTAssertEqual(button.title, "Cancel", "Incorrect title of button")
            }
            else {
                XCTFail("No button")
            }
            
            expectation.fulfill()
        }
        
        Alert(title: "Title", message: "Message").addAction("Cancel").show()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testShowOkay() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 1, "Incorrect number of buttons")
            
            if let button = actions.first as? UIAlertAction {
                XCTAssertEqual(button.title, "Okay", "Incorrect title of button")
                XCTAssertEqual(button.style, UIAlertAction.Style.cancel, "Incorrect style of button")
            }
            else {
                XCTFail("No button")
            }
            
            expectation.fulfill()
        }
        
        Alert(title: "Title", message: "Message").showOkay()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testAddTextField() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertNotNil(fields, "Fields was nil")
            if fields != nil {
                XCTAssertEqual(fields!.count, 1, "Incorrect number of fields")
            }
            
            if let field = fields?.first as? UITextField, let placeholder = field.placeholder {
                XCTAssertEqual(placeholder, "the placeholder", "incorrect placeholder")
            }
            else {
                XCTFail("No text field")
            }
            
            expectation.fulfill()
        }
        
        var textField = UITextField()
        textField.placeholder = "the placeholder"
        
        Alert(message: "text field alert").addTextField(&textField).showOkay()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testAddMultipleField() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertNotNil(fields, "Fields was nil")
            if fields != nil {
                XCTAssertEqual(fields!.count, 2, "Incorrect number of fields")
            }
            
            if let first = fields?.first as? UITextField,
                let second = fields?.last as? UITextField {
                    
                    XCTAssertNotNil(first.placeholder, "placeholder nil")
                    if first.placeholder != nil {
                        XCTAssertEqual(first.placeholder!, "username", "incorrect placeholder")
                    }
                    XCTAssertEqual(first.text, "user", "incorrect text")
                    
                    XCTAssertNotNil(second.placeholder, "placeholder nil")
                    if second.placeholder != nil {
                        XCTAssertEqual(second.placeholder!, "password", "incorrect placeholder")
                    }
                    XCTAssertTrue(second.isSecureTextEntry, "Secure text entry not enabled")
            }
            else {
                XCTFail("No text field")
            }
            
            expectation.fulfill()
        }
        
        var first = UITextField()
        first.placeholder = "username"
        first.text = "user"
        
        var second = UITextField()
        second.placeholder = "password"
        second.isSecureTextEntry = true
        
        Alert(message: "text field alert").addTextField(&first).addTextField(&second).showOkay()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
	
	func testTextFieldsInCallback() {
		let expectation = self.expectation(description: "Show override")
		
		var firstField = UITextField()
		var secondField = UITextField()
		
		LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
			XCTAssertNotNil(fields, "Fields was nil")
			if fields != nil {
				XCTAssertEqual(fields!.count, 2, "Incorrect number of fields")
			}
			
			if let first = fields?.first as? UITextField,
				let second = fields?.last as? UITextField {
				
				first.text = "TESTING!"
				second.text = "ALSO TESTING!"
				
				XCTAssertEqual(firstField.text, first.text)
				XCTAssertEqual(secondField.text, second.text)
			}
			else {
				XCTFail("No text field")
			}
			
			expectation.fulfill()
		}
		
		Alert(message: "text field alert").addTextField(&firstField).addTextField(&secondField).showOkay()
		
		waitForExpectations(timeout: 0.5, handler: nil)
	}
	
    func testNevermindExtension() {
        let expectation = self.expectation(description: "Nevermind Extension")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 1, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.alert, "Incorrect Style of the alert")
            
            if let button = actions.first as? UIAlertAction {
                XCTAssertEqual(button.title, "Nevermind", "Incorrect title of button")
            }
            else {
                XCTFail("No button")
            }
            
            expectation.fulfill()
        }
        
        Alert().showNevermind()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
	
	func testSetTint() {
		let tint = UIColor.green
		let alert = Alert(message: "Tinted alert").tint(tint).getAlertController()
		
		XCTAssertEqual(alert.view.tintColor, tint)
	}
}


class ActionSheetTests: XCTestCase {
    func testInit() {
        let controller = ActionSheet().getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithTitle() {
        let controller = ActionSheet(title: "the title").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilTitle() {
        let controller = ActionSheet(title: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
    }
    
    func testInitWithMessage() {
        let controller = ActionSheet(message: "the message").getAlertController()
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertNotNil(controller.title, "The title was nil")
        if controller.title != nil {
            XCTAssertEqual(controller.title!, "", "The title was not blank")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilMessage() {
        let controller = ActionSheet(message: nil).getAlertController()
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndMessage() {
        let controller = ActionSheet(title: "the title", message: "the message").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndMessage() {
        let controller = ActionSheet(title: nil, message: "the message").getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndNilMessage() {
        let controller = ActionSheet(title: "the title", message: nil).getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let _ = controller.title {
            XCTAssertEqual(controller.title!, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndNilMessage() {
        let controller = ActionSheet(title: nil, message: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertController.Style.actionSheet, "The controller type was incorrect")
    }
    
    func testShow() {
        let expectation = self.expectation(description: "Show override")
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions, fields) -> Void in
            XCTAssertEqual(actions.count, 1, "Incorrect number of buttons")
            XCTAssertEqual(style, UIAlertController.Style.actionSheet, "Incorrect Style of the alert")
            
            if let button = actions.first as? UIAlertAction {
                XCTAssertEqual(button.title, "Cancel", "Incorrect title of button")
            }
            else {
                XCTFail("No button")
            }
            
            expectation.fulfill()
        }
        
        ActionSheet(title: "Title", message: "Message").addAction("Cancel").show()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testGithubIssue26() {
        //https://github.com/lightningkite/LKALertController/issues/26
        ActionSheet().addAction("Test", style: .default, handler: { _ in print("Test") }).show()
    }
	
	func testSetTint() {
		let tint = UIColor.green
		let alert = ActionSheet(message: "Tinted alert").tint(tint).getAlertController()
		
		XCTAssertEqual(alert.view.tintColor, tint)
	}
}


extension Alert {
	///Shortcut method for adding a nevermind button and showing the alert
	public func showNevermind() {
		_ = addAction("Nevermind", style: .cancel, preferredAction: false, handler: nil)
		show()
	}
}

