//
//  TViewController.m
//  TAlertView
//
//  Created by Washington on 11/25/2014.
//  Copyright (c) 2014 Washington. All rights reserved.
//

#import "TViewController.h"
#import <TAlertView.h>

@implementation TViewController

- (IBAction)alert1:(id)sender {
    [[[TAlertView alloc] initWithTitle:@"Great!" andMessage:@"This is a basic alert"] show];
}

- (IBAction)alert2:(id)sender {
    [[[TAlertView alloc] initWithTitle:nil andMessage:@"This alert is shown as message"] showAsMessage];
}

- (IBAction)alert3:(id)sender {
    NSArray * buttons = @[@"Action 1", @"Action 2", @"Action 3"];
    TAlertView *alert = [[TAlertView alloc] initWithTitle:@"Options"
                                                  message:@"This alert can manage different actions"
                                                  buttons:buttons
                                              andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                                                  NSLog(@"%@", buttons[buttonIndex]);
                                              }];
    [alert show];
}

- (IBAction)alert4:(id)sender {
    TAlertView *alert = [[TAlertView alloc] initWithTitle:nil
                                                  message:@"This alert cannot be closed with no tapping the Ok button"
                                                  buttons:@[@"Ok"]
                                              andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {}];
    alert.style = TAlertViewStyleError;
    alert.tapToClose = NO;
    [alert show];
}

- (IBAction)alert5:(id)sender {
    TAlertView *alert = [[TAlertView alloc] initWithTitle:@"Auto Close"
                                               andMessage:@"This message will self-destruct in five seconds"];
    alert.timeToClose = 5;
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    alert.style = TAlertViewStyleInformation;
    [alert showAsMessage];
}

- (IBAction)alert6:(id)sender {
    TAlertView *alert = [[TAlertView alloc] initWithTitle:nil
                                                  message:@"This alert show two buttons horizontally"
                                                  buttons:@[@"No", @"Yes"]
                                              andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {}];
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    [alert showAsMessage];
}

- (IBAction)alert7:(id)sender {
    [TAlertView hideAll];
    
    TAlertView *alert = [[TAlertView alloc] initWithTitle:@"Great!"
                                               andMessage:nil];
    alert.style = TAlertViewStyleSuccess;
    [alert show];
}

@end
