//
//  TAlertView.m
//  tell
//
//  Created by Washington Miranda on 04/06/14.
//  Copyright (c) 2014 apptell. All rights reserved.
//

#import "TAlertView.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const TAlertViewHideAllNotificationKey = @"TAlertViewHideAllNotificationKey";
static NSInteger  const TAlertViewHorizontalButtonCountMax = 2;

typedef NS_ENUM(NSUInteger, TAlertViewDisplayStyle) {
    TAlertViewDisplayStyleDynamics = 0,
    TAlertViewDisplayStyleMessage
};

@interface TAlertView()

@property (assign, nonatomic) TAlertViewDisplayStyle alertDisplayStyle;
@property (strong, nonatomic) void (^callBackBlock)(TAlertView *alertView, NSInteger buttonIndex);
@property (strong, nonatomic) UIView *alertView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachmentBehaviour;

@property (assign, nonatomic) CGRect screenFrame;

@property (strong, nonatomic) NSMutableArray        *buttonsViews;
@property (strong, nonatomic) NSMutableArray        *separatorsLines;
@property (strong, nonatomic) UILabel               *messageLabel;
@property (strong, nonatomic) UILabel               *titleLabel;
@property (strong, nonatomic) UILabel               *closeLabel;

@end

@implementation TAlertView

+ (void)initialize
{
    if (self != [TAlertView class])
        return;
    
    TAlertView *appearance          = [self appearance];
    appearance.alertBackgroundColor = [UIColor whiteColor];
    appearance.titleFont            = [UIFont systemFontOfSize:18];
    appearance.messageColor         = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    appearance.messageFont          = [UIFont systemFontOfSize:14];
    appearance.buttonsTextColor     = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    appearance.buttonsFont          = [UIFont systemFontOfSize:14];
    appearance.separatorsLinesColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f];
    appearance.tapToCloseFont       = [UIFont systemFontOfSize:10];
    appearance.tapToCloseColor      = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
    appearance.tapToCloseText       = @"Tap to close";
}

+(void)hideAll
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TAlertViewHideAllNotificationKey object:nil];
}

-(id)init
{
    return [self initWithTitle:nil message:nil buttons:nil andCallBack:^(TAlertView *alertView, NSInteger buttonIndex){}];
}

-(id)initWithTitle:(NSString*)title andMessage:(NSString*)message
{
    return [self initWithTitle:title message:message buttons:nil andCallBack:^(TAlertView *alertView, NSInteger buttonIndex){}];
}

-(id)initWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(TAlertView *alertView, NSInteger buttonIndex))callBackBlock
{
    if (self = [super init]) {
        _callBackBlock          = callBackBlock;
        _tapToClose             = YES;
        _timeToClose            = 0;
        _title                  = title;
        _message                = message;
        _buttonsTexts           = buttons;
        _buttonsAlign           = TAlertViewButtonsAlignVertical;
        _buttonsViews           = [[NSMutableArray alloc] init];
        _separatorsLines        = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark UI_APPEARANCE_SELECTOR setters

-(void)setAlertBackgroundColor:(UIColor *)alertBackgroundColor {
    _alertBackgroundColor = alertBackgroundColor;
    
    if (_alertView) {
        _alertView.backgroundColor = alertBackgroundColor;
    }
}

-(void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    if (_titleLabel) {
        _titleLabel.font = titleFont;
    }
}

-(void)setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    
    if (_messageLabel) {
        _messageLabel.textColor = messageColor;
    }
}

-(void)setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    
    if (_messageLabel) {
        _messageLabel.font = messageFont;
    }
}

-(void)setButtonsTextColor:(UIColor *)buttonsTextColor {
    _buttonsTextColor = buttonsTextColor;
    
    for (UIView *button in _buttonsViews) {
        for (id buttonSubview in [button subviews]) {
            if ([buttonSubview isKindOfClass:[UILabel class]]) {
                ((UILabel*)buttonSubview).textColor = buttonsTextColor;
            }
        }
    }
}

-(void)setButtonsFont:(UIFont *)buttonsFont {
    _buttonsFont = buttonsFont;
    
    for (UIView *button in _buttonsViews) {
        for (id buttonSubview in [button subviews]) {
            if ([buttonSubview isKindOfClass:[UILabel class]]) {
                ((UILabel*)buttonSubview).font = buttonsFont;
            }
        }
    }
}

-(void)setSeparatorsLinesColor:(UIColor *)separatorsLinesColor {
    _separatorsLinesColor = separatorsLinesColor;
    
    if (_separatorsLines) {
        for (UIView *separatorsLine in _separatorsLines) {
            separatorsLine.backgroundColor = separatorsLinesColor;
        }
    }
}

-(void) setTapToCloseFont:(UIFont *)tapToCloseFont {
    _tapToCloseFont = tapToCloseFont;
    
    if (_closeLabel) {
        _closeLabel.font = _tapToCloseFont;
    }
}

-(void) setTapToCloseColor:(UIColor *)tapToCloseColor {
    _tapToCloseColor = tapToCloseColor;
    
    if (_closeLabel) {
        _closeLabel.textColor = tapToCloseColor;
    }
}

-(void) setTapToCloseText:(NSString *)tapToCloseText {
    _tapToCloseText = tapToCloseText;
    
    if (_closeLabel) {
        [self setLabel:_closeLabel text:_tapToCloseText];
        
        CGRect aletViewFrame = _alertView.frame;
        aletViewFrame.size.height = CGRectGetMaxY(_closeLabel.frame)+(self.frame.size.height/75.0f)/2.0f;
        _alertView.frame = aletViewFrame;
    }
}

-(void)setTitleColor:(UIColor*)color forAlertViewStyle:(TAlertViewStyle)style {
    if (self.style == style && _titleLabel) {
        _titleLabel.textColor = color;
    }
}

-(void)setDefaultTitle:(NSString*)defaultTitle forAlertViewStyle:(TAlertViewStyle)style {
    if (self.style == style && _titleLabel) {
        _titleLabel.text = defaultTitle;
    }
}

#pragma mark setters

-(void)setButtonsTexts:(NSArray *)buttons
{
    _buttonsTexts = buttons;
    [self setButtonsAlign:_buttonsAlign];
}

-(void)setButtonsAlign:(TAlertViewButtonsAlign)buttonsAlign
{
    if (buttonsAlign == TAlertViewButtonsAlignHorizontal && _buttonsTexts &&
        [_buttonsTexts count] > TAlertViewHorizontalButtonCountMax) {
#ifdef DEBUG
        NSLog(@"TAlertViewButtonsAlignHorizontal cant be used with more than %i", (int)TAlertViewHorizontalButtonCountMax);
#endif
        _buttonsAlign = TAlertViewButtonsAlignVertical;
    } else {
        _buttonsAlign = buttonsAlign;
    }
}

-(void)show
{
    _alertDisplayStyle = TAlertViewDisplayStyleDynamics;
    
    [self addSubviewsWithOverlay:YES];
    [self addToSuperview];
    
    _alertView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - _alertView.frame.size.height/2.0f);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:TAlertViewHideAllNotificationKey object:nil];
    
    [self becomeFirstResponder];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[_alertView]];
    [_animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *groundCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_alertView]];
    [groundCollisionBehavior addBoundaryWithIdentifier:@"ground"
                                             fromPoint:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame))
                                               toPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame))];
    [_animator addBehavior:groundCollisionBehavior];
    
    UICollisionBehavior *wall1CollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_alertView]];
    [wall1CollisionBehavior addBoundaryWithIdentifier:@"wall1"
                                            fromPoint:CGPointMake(0, 0)
                                              toPoint:CGPointMake(0, CGRectGetMaxY(self.frame))];
    [_animator addBehavior:wall1CollisionBehavior];
    
    UICollisionBehavior *wall2CollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_alertView]];
    [wall2CollisionBehavior addBoundaryWithIdentifier:@"wall2"
                                            fromPoint:CGPointMake(CGRectGetMaxX(self.frame), 0)
                                              toPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
    [_animator addBehavior:wall2CollisionBehavior];
    
    UIDynamicItemBehavior *alertViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_alertView]];
    alertViewBehavior.elasticity = 0.10;
    CGFloat angularVelocity = (((float)rand() / RAND_MAX)-0.5f)*0.4f;
    [alertViewBehavior addAngularVelocity:angularVelocity forItem:_alertView];
    [_animator addBehavior:alertViewBehavior];
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_alertView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.0f, 15.0f);
    [_animator addBehavior:pushBehavior];
    pushBehavior.active = YES;
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) { }];
    
    if (_timeToClose) {
        __weak TAlertView *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeToClose * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hide];
        });
    }
}

-(void)showAsMessage
{
    _alertDisplayStyle = TAlertViewDisplayStyleMessage;
    
    [self addSubviewsWithOverlay:NO];
    [self addToSuperview];
    
    _alertView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - _alertView.frame.size.height/2.0f);
    self.alpha = 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:TAlertViewHideAllNotificationKey object:nil];
    
    [self becomeFirstResponder];
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _alertView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + _alertView.frame.size.height/2.0f);
                     }
                     completion:^(BOOL finished) { }];
    
    if (_timeToClose) {
        __weak TAlertView *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeToClose * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hide];
        });
    }
}

-(void)hide
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignFirstResponder];
    
    if (_alertDisplayStyle == TAlertViewDisplayStyleDynamics) {
        for (id behavior in [_animator behaviors]) {
            if ([behavior isKindOfClass:[UICollisionBehavior class]]) {
                [_animator removeBehavior:behavior];
            }
        }
        [UIView animateWithDuration:0.4f
                              delay:0.3f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    } else {
        [UIView animateWithDuration:0.4f
                              delay:0.3f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 5.0f;
                             _alertView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - _alertView.frame.size.height/2.0f);
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark private

-(void)addSubviewsWithOverlay:(BOOL)withOverlay
{
    BOOL displayStyleDynamics = (_alertDisplayStyle == TAlertViewDisplayStyleDynamics);
    
    UIColor *titleColor = [UIColor blackColor];
    NSString *defaultTitle = nil;
    
    switch (_style) {
        case TAlertViewStyleError:
            titleColor = [UIColor redColor];
            defaultTitle = @"Oops...";
            break;
        case TAlertViewStyleWarning:
            titleColor = [UIColor orangeColor];
            defaultTitle = @"Warning";
            break;
        case TAlertViewStyleSuccess:
            titleColor = [UIColor greenColor];
            defaultTitle = @"Success!";
            break;
        case TAlertViewStyleInformation:
            titleColor = [UIColor blueColor];
            break;
        case TAlertViewStyleNeutral:
        default:
            break;
    }
    
    if (!_title) {
        _title = defaultTitle;
    }
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = withOverlay ? [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.6f] : [UIColor clearColor];
    
    CGFloat insideHorisontalMargin = self.frame.size.width/15.0f;
    CGFloat insideVerticalMargin = self.frame.size.height/75.0f;
    CGFloat outsideMargin = self.frame.size.width/12.0f;
    
    CGRect aletViewFrame = CGRectMake(displayStyleDynamics?outsideMargin:0, outsideMargin * 4, self.frame.size.width - (displayStyleDynamics?(2*outsideMargin):0), 0);
    
    _alertView = [[UIView alloc] initWithFrame:aletViewFrame];
    _alertView.backgroundColor = _alertBackgroundColor;
    _alertView.layer.cornerRadius = displayStyleDynamics?5:0;
    [_alertView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(aletViewPanGesture:)]];
    [self addSubview:_alertView];
    
    CGFloat yPos = insideVerticalMargin;
    
    if(!displayStyleDynamics && ![UIApplication sharedApplication].statusBarHidden) {
        yPos += 20;
    }
    
    if (_title) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideHorisontalMargin, yPos, aletViewFrame.size.width - 2*insideHorisontalMargin, 0)];
        _titleLabel.font = _titleFont;
        
        _titleLabel.textColor = titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setLabel:_titleLabel text:_title];
        [_alertView addSubview:_titleLabel];
        yPos = CGRectGetMaxY(_titleLabel.frame) + insideVerticalMargin;
    }
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideHorisontalMargin, yPos, aletViewFrame.size.width - 2*insideHorisontalMargin, 0)];
    _messageLabel.font = _messageFont;
    _messageLabel.textColor = _messageColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self setLabel:_messageLabel text:_message];
    [_alertView addSubview:_messageLabel];
    
    yPos = CGRectGetMaxY(_messageLabel.frame) + insideVerticalMargin;
    
    _buttonsViews = [[NSMutableArray alloc] init];
    
    if (_buttonsTexts && [_buttonsTexts count]) {
        NSInteger buttonIndex = 0;
        CGFloat   xPos = 0;
        for (NSString *buttonTitle in _buttonsTexts) {
            
            CGFloat width = aletViewFrame.size.width;
            CGFloat height = 20;
            
            UIView *separatorsLine = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, width, 1)];
            separatorsLine.backgroundColor = _separatorsLinesColor;
            [_alertView addSubview:separatorsLine];
            [_separatorsLines addObject:separatorsLine];
            yPos += insideVerticalMargin;
            
            if (_buttonsAlign == TAlertViewButtonsAlignHorizontal) {
                if (buttonIndex > 0) {
                    yPos -= insideVerticalMargin;
                    separatorsLine.frame = CGRectMake(xPos, yPos - insideVerticalMargin, 1, height + insideVerticalMargin*2);
                }
                width /= [_buttonsTexts count];
            }
            
            UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
            buttonView.tag = buttonIndex;
            UITapGestureRecognizer *buttonTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
            [buttonView addGestureRecognizer:buttonTapGestureRecognizer];
            [_alertView addSubview:buttonView];
            [_buttonsViews addObject:buttonView];
            
            UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonView.frame.size.width, buttonView.frame.size.height)];
            buttonLabel.font = _buttonsFont;
            buttonLabel.textColor = _buttonsTextColor;
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            buttonLabel.text = buttonTitle;
            [buttonView addSubview:buttonLabel];
            
            if ((_buttonsAlign == TAlertViewButtonsAlignHorizontal) && buttonIndex<([_buttonsTexts count]-1)) {
                xPos += width;
            } else {
                yPos = CGRectGetMaxY(buttonView.frame)+insideVerticalMargin/2.0f;
            }
            
            buttonIndex++;
        }
        yPos += insideVerticalMargin/2.0f;
        
    } else if (_tapToClose) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        _closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideHorisontalMargin, yPos, aletViewFrame.size.width - 2*insideHorisontalMargin, 0)];
        _closeLabel.font = _tapToCloseFont;
        _closeLabel.textColor = _tapToCloseColor;
        _closeLabel.textAlignment = NSTextAlignmentCenter;
        [self setLabel:_closeLabel text:_tapToCloseText];
        [_alertView addSubview:_closeLabel];
        
        yPos = CGRectGetMaxY(_closeLabel.frame)+insideVerticalMargin/2.0f;
    }
    
    aletViewFrame.size.height = yPos;
    _alertView.frame = aletViewFrame;
    
//    if (!withOverlay) {
//        self.clipsToBounds = NO;
//        self.frame = _alertView.frame;
//    }
}

-(void)addToSuperview
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)]) {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if(event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
       [self shake];
}

-(void)shake
{
    CGFloat angularVelocity = ((float)rand()/RAND_MAX)-0.5f;
    UIDynamicItemBehavior *alertViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_alertView]];
    [alertViewBehavior addAngularVelocity:angularVelocity forItem:_alertView];
    [_animator addBehavior:alertViewBehavior];
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_alertView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.magnitude = 0.0f;
    pushBehavior.angle = 0.0f;
    [_animator addBehavior:pushBehavior];
    pushBehavior.pushDirection = CGVectorMake((((float)rand()/RAND_MAX)-0.5f)*20.0f, -10.0f -((float)rand()/RAND_MAX)*10.0f);
    pushBehavior.active = YES;
}

-(void)aletViewPanGesture:(UIPanGestureRecognizer*)gestureRecognizer
{
    if (_tapToClose) {
        CGPoint location = [gestureRecognizer locationInView:self];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            for (id behavior in [_animator behaviors]) {
                if ([behavior isKindOfClass:[UICollisionBehavior class]]) {
                    [_animator removeBehavior:behavior];
                }
            }
            CGPoint pointWithinAnimatedView = [gestureRecognizer locationInView:gestureRecognizer.view];
            UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gestureRecognizer.view.bounds.size.width / 2.0,
                                           pointWithinAnimatedView.y - gestureRecognizer.view.bounds.size.height / 2.0);
            _panAttachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:_alertView offsetFromCenter:offset attachedToAnchor:location];
            _panAttachmentBehaviour.damping = 0.5;
            [_animator addBehavior:_panAttachmentBehaviour];
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            _panAttachmentBehaviour.anchorPoint = location;
        } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [_animator removeBehavior:_panAttachmentBehaviour];
            CGPoint velocity = [gestureRecognizer velocityInView:self];
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_alertView] mode:UIPushBehaviorModeInstantaneous];
            pushBehavior.pushDirection = CGVectorMake(velocity.x/80.0f, velocity.y/80.0f);
            [_animator addBehavior:pushBehavior];
            pushBehavior.active = YES;
            
            [self hide];
        }
    }
}

-(void)buttonTapped:(UITapGestureRecognizer*)tapGestureRecognizer
{
    UIView *buttonView = tapGestureRecognizer.view;
    NSInteger buttonIndex = buttonView.tag;
    if (_callBackBlock) {
        _callBackBlock(self, buttonIndex);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         buttonView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              buttonView.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [self hide];
}

-(void)setLabel:(UILabel*)label text:(NSString*)text {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    CGRect labelRect = label.frame;
    labelRect.size.height = 0;
    CGRect newRect = [text
                      boundingRectWithSize:labelRect.size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:label.font}
                      context:nil];
    labelRect.size.height = newRect.size.height;
    label.frame = labelRect;
    label.text = text;
}

@end
