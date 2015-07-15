# LKAlertController

[![CI Status](http://img.shields.io/travis/lightningkite/LKAlertController.svg?style=flat)](https://travis-ci.org/lightningkite/LKAlertController)
[![Version](https://img.shields.io/cocoapods/v/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)
[![License](https://img.shields.io/cocoapods/l/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)
[![Platform](https://img.shields.io/cocoapods/p/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)

An easy to use UIAlertController builder for swift

## Features
* Short and simple syntax for creating both Alerts and ActionSheets from UIAlertController
* String together methods to build more complex alerts and action sheets

## Basic Usage

### Alert
----
``` Swift
Alert(title: "Title", message: "Message")
	.addAction("Cancel")
	.addAction("Delete", style: .Destructive, handler: { _ in
		//Delete the object
	}).show()
```

### Action Sheet
----
``` Swift
ActionSheet(title: "Title", message: "Message")
	.addAction("Cancel")
	.addAction("Delete", style: .Destructive, handler: { _ in
		//Delete the object
	}).show()
```

## Detailed Usage

There are two seperate classes for creating `UIAlertControllers`, `Alert`, and `ActionSheet`. These are used to simplify the creation of the controller. Both can be initialized with or without both a title and message.

``` Swift
Alert()
ActionSheet()

Alert(title: "My title")
ActionSheet(title: "My title")

Alert(message: "My message")
ActionSheet(message: "My message")

Alert(title: "My title", message: "My message")
ActionSheet(title: "My title", message: "My message")
```

Add various actions to the controller using `addAction`. By default the button will be styled `Cancel`, but this can be configured on a per button basis, along with the handler that is called if the button is clicked. The possible styles are `Cancel`, `Default`, and `Destructive`. These methods can be strung together to add more buttons to the controller.

``` Swift
ActionSheet()
	.addAction("Cancel")
	.addAction("Save", style: .Default) {
		saveTheObject()
	}
	.addAction("Delete", style: Destructive) {
		deleteTheObject()
	}
```

The controller can be presented by calling `show()`. It will be animated by default.

``` Swift
Alert()
	.addAction("Okay")
	.show()
	
ActionSheet()
	.addAction("Delete", style: .Destructive) {
		delete()
	}
	.addAction("Cancel")
	.show(animated: true) {
		controllerWasPresented()
	}
```

There is also a shortcut for quickly showing an alert with an `Okay` button. After initializing an alert, call `showOkay`

``` Swift
Alert(title: "Stuff has happened").showOkay()
```

##Testing

You can add an override for the `show` method to make it easy to add unit tests for your alerts.

``` Swift
func testDeleteOpensConfirmationAlert() {
	let expectation = expectationWithDescription("Show override")

	LKAlertController.overrideShowForTesting { (style, title, message, actions) -> Void in 
		
		XCTAssertEquals(title, "Are you sure you want to delete?", "Alert title was incorrect")
		
		expectation.fulfill()
	}
	
	model.delete()
	
	//If the override is never called, and the expectation is not fulfilled, the test will fail
	waitForExpectations(0.5, handler: nil)
}
```

## Installation

LKAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LKAlertController"
```

## Issues Questions and Contributing
Have an issue, or want to request a feature? Create an issue in github.

Want to contribute? Add yourself to the authors list, and create a pull request.

## Author

Erik Sargent, [erik@lightningkite.com](mailto:erik@lightningkite.com)

## License

LKAlertController is available under the MIT license. See the LICENSE file for more info.
