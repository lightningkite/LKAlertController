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
        let controller = LKAlertController(style: .Alert).getAlertController()
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The style was not initialized correctly")
    }
    
    func testCreateAlertControllerActionSheet() {
        let controller = LKAlertController(style: .ActionSheet).getAlertController()
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The style was not initialized correctly")
    }
    
    func testAddAction() {
        let handler: (UIAlertAction!) -> Void = { (UIAlertAction) -> Void in
            println("TESTING")
        }
        
        let controller = LKAlertController(style: .Alert).addAction("Okay", style: .Default, handler: handler).getAlertController()
        XCTAssertEqual(controller.actions.count, 1, "The number of actions was incorrect")
        
        if let action = controller.actions.first as? UIAlertAction {
            XCTAssertEqual(action.title, "Okay", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertActionStyle.Default, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the action")
        }
    }
    
    func testAddMultipleActions() {
        let handler: (UIAlertAction!) -> Void = { (UIAlertAction) -> Void in
            println("TESTING")
        }
        
        let controller = LKAlertController(style: .Alert)
            .addAction("Okay", style: .Default, handler: handler).addAction("Cancel", style: .Cancel, handler: handler)
            .getAlertController()
        
        XCTAssertEqual(controller.actions.count, 2, "The number of actions was incorrect")
        
        if let action = controller.actions.first as? UIAlertAction {
            XCTAssertEqual(action.title, "Okay", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertActionStyle.Default, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the first action")
        }
        
        if let action = controller.actions.last as? UIAlertAction {
            XCTAssertEqual(action.title, "Cancel", "The title of the action was incorrect")
            XCTAssertEqual(action.style, UIAlertActionStyle.Cancel, "The style was incorrect")
        }
        else {
            XCTFail("Could not load the last action")
        }
    }
    
    func testOverrideShowForTesting() {
        let expectation = expectationWithDescription("Show override")
        
        let theStyle = UIAlertControllerStyle.Alert
        let theTitle = "Alert Title"
        let theMessage = "Alert Message"
        
        LKAlertController.overrideShowForTesting { (style, title, message, actions) -> Void in
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
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}


class AlertTests: XCTestCase {
    func testInit() {
        let controller = Alert().getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithTitle() {
        let controller = Alert(title: "the title").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitle() {
        let controller = Alert(title: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithMessage() {
        let controller = Alert(message: "the message").getAlertController()
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithNilMessage() {
        let controller = Alert(message: nil).getAlertController()
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
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
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndMessage() {
        let controller = Alert(title: nil, message: "the message").getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndNilMessage() {
        let controller = Alert(title: "the title", message: nil).getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(controller.title!, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndNilMessage() {
        let controller = Alert(title: nil, message: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.Alert, "The controller type was incorrect")
    }
}


class ActionSheetTests: XCTestCase {
    func testInit() {
        let controller = ActionSheet().getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
    
    func testInitWithTitle() {
        let controller = ActionSheet(title: "the title").getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(title, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
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
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilMessage() {
        let controller = ActionSheet(message: nil).getAlertController()
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
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
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndMessage() {
        let controller = ActionSheet(title: nil, message: "the message").getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNotNil(controller.message, "The message was nil")
        if let message = controller.message {
            XCTAssertEqual(message, "the message", "The message was incorrect")
        }
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
    
    func testInitWithTitleAndNilMessage() {
        let controller = ActionSheet(title: "the title", message: nil).getAlertController()
        XCTAssertNotNil(controller.title, "The title was nil")
        if let title = controller.title {
            XCTAssertEqual(controller.title!, "the title", "The title was incorrect")
        }
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
    
    func testInitWithNilTitleAndNilMessage() {
        let controller = ActionSheet(title: nil, message: nil).getAlertController()
        XCTAssertNil(controller.title, "The title was not nil")
        XCTAssertNil(controller.message, "The message was not nil")
        XCTAssertEqual(controller.preferredStyle, UIAlertControllerStyle.ActionSheet, "The controller type was incorrect")
    }
}