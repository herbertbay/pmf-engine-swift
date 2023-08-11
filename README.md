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

##### 1. First you should 
    import pmf_engine_swift

##### 2. Configure with your accountId and userId in the `didFinishLaunchingWithOptions`

```Swift
    PMFEngine.default.configure(accountId: "accountID", userId: UUID().uuidString)
``` 

##### 3. Track Event

```Swift
  PMFEngine.default.trackKeyEvent("journal")
``` 

##### 4. Customise View

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

##### 5. Show Popup If Needed

```Swift
  PMFEngine.default.showPMFPopup(popupView: popupView, onViewController: topController)
```

## License

pmf-engine-swift is available under the MIT license. See the LICENSE file for more info.
