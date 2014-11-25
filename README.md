# TAlertView

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

TAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

	pod "TAlertView"

## Example

![Screenshot of Input Examples](Github/Example.gif)

```objc

//Alert 6
TAlertView *alert = [[TAlertView alloc] initWithTitle:nil
                                                  message:@"This alert show two buttons horizontally"
                                                  buttons:@[@"No", @"Yes"]
                                              andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {}];
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    [alert showAsMessage];

//Alert 1
[[[TAlertView alloc] initWithTitle:@"Great!" andMessage:@"This is a basic alert"] show];



```

## Author

Washington Miranda, mirandaacevedo@gmail.com

## License

TAlertView is available under the MIT license. See the LICENSE file for more info.

