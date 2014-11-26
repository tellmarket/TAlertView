# TAlertView

## Preview

![Screenshot of Input Examples](Github/Example.gif)

## Features

- simple to use
- block syntax
- physically animated user interaction

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

TAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

	pod "TAlertView"

## How To Use It

### Simple

```
[[[TAlertView alloc] initWithTitle:@"Great!" andMessage:@"This is a basic alert"] show];

```


### Or with buttons


```
TAlertView *alert = [[TAlertView alloc] initWithTitle:nil
                                              message:@"This alert show two buttons horizontally"
                                              buttons:@[@"No", @"Yes"]
                                          andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                                                          //Your actions
                                                      }];
alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
[alert showAsMessage];

```

## Author

Washington Miranda, mirandaacevedo@gmail.com

## License

TAlertView is available under the MIT license. See the LICENSE file for more info.

