//
//  TAlertView.h
//  tell
//
//  Created by Washington Miranda on 04/06/14.
//  Copyright (c) 2014 apptell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TAlertViewStyle) {
    TAlertViewStyleNeutral = 0,
    TAlertViewStyleInformation,
    TAlertViewStyleSuccess,
    TAlertViewStyleWarning,
    TAlertViewStyleError
};

typedef NS_ENUM(NSUInteger, TAlertViewButtonsAlign) {
    TAlertViewButtonsAlignVertical = 0,
    TAlertViewButtonsAlignHorizontal
};

@interface TAlertView : UIView

@property (assign, nonatomic) BOOL tapToClose;
@property (assign, nonatomic) CGFloat timeToClose;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) TAlertViewStyle style;
@property (assign, nonatomic) TAlertViewButtonsAlign buttonsAlign;
@property (strong, nonatomic) NSArray *buttons;

+(void)hideAll;

-(id)init;
-(id)initWithTitle:(NSString*)title andMessage:(NSString*)message;
-(id)initWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(TAlertView *alertView, NSInteger buttonIndex))callBackBlock;

-(void)show;
-(void)showAsMessage;
-(void)hide;

@end
