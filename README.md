# pmf-engine-swift

[![Version](https://img.shields.io/cocoapods/v/pmf-engine-swift.svg?style=flat)](https://cocoapods.org/pods/pmf-engine-swift)
[![License](https://img.shields.io/cocoapods/l/pmf-engine-swift.svg?style=flat)](https://cocoapods.org/pods/pmf-engine-swift)
[![Platform](https://img.shields.io/cocoapods/p/pmf-engine-swift.svg?style=flat)](https://cocoapods.org/pods/pmf-engine-swift)

pmf-engine-swift is an iOS framework that empowers developers to seamlessly integrate interactive question prompts for valuable user feedback, ensuring two weeks of app usage and tracking at least two key events to ensure meaningful insights and engagement.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 13.0+
- Swift 5.0+

## Installation

pmf-engine-swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'pmf-engine-swift'
```

## Usage

### Configuration

##### 1. To get started, import the pmf_engine_swift library into your project.
    import pmf_engine_swift

##### 2. In your AppDelegate's `didFinishLaunchingWithOptions` method, configure the PMF Engine with your `accountId` and a unique `userId`.

```Swift
  PMFEngine.default.configure(accountId: "accountID", userId: UUID().uuidString)
``` 

##### 3. Track Events

Use the PMF Engine to track events within your application. You can either use a default event or specify a custom event.

```Swift
  PMFEngine.default.trackKeyEvent() // Track a default event
  PMFEngine.default.trackKeyEvent("journal") // Track a custom event
``` 

```Swift
  PMFEngine.default.trackKeyEvent("journal")
``` 

##### 4. Customize the Feedback Popup (Optional)

```Swift
  let popupView = PMFEnginePopupView()

  popupView.emoji = UIImage(named: "smilling-panda")
  popupView.title = "Pleeeeease! 🙏\n Help us to improve \nto help others!"
  popupView.subTitle = "By answering a few simple questions."
  popupView.confirmTitle = "Yes, happy to help!"
  popupView.cancelTitle = "No, I don’t want to help!"

  popupView.containerBackgroundColor = UIColor.white
  popupView.closeButtonTitleColor = UIColor.lightGray
  popupView.pmfButtonBackgroundColor = UIColor.purple
  popupView.pmfButtonTitleColor = UIColor.white

  popupView.confirmFont = UIFont.systemFont(ofSize: 17, weight: .bold)
  popupView.cancelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
``` 

##### 5. Show the Feedback Popup

To show the form directly from the top controller:

```Swift
  // if you want to show form directly from the top controller
  PMFEngine.default.showPMFPopup()
```

To use a custom popup view and a specific view controller:

```Swift
  PMFEngine.default.showPMFPopup(popupView: popupView, onViewController: viewController)
```

## License

pmf-engine-swift is available under the MIT license. See the LICENSE file for more info.
