# LKAlertController

[![CI Status](http://img.shields.io/travis/Erik Sargent/LKAlertController.svg?style=flat)](https://travis-ci.org/Erik Sargent/LKAlertController)
[![Version](https://img.shields.io/cocoapods/v/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)
[![License](https://img.shields.io/cocoapods/l/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)
[![Platform](https://img.shields.io/cocoapods/p/LKAlertController.svg?style=flat)](http://cocoapods.org/pods/LKAlertController)

An easy to use UIAlertController builder for swift

### Features
* Short and simple syntax for creating both Alerts and ActionSheets from UIAlertController
* String together methods to build more complex alerts and action sheets

## Usage

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
