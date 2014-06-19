//
//  ViewController.h
//  wireless_Mouse
//
//  Created by Matthew Shrago on 5/28/14.
//  Copyright (c) 2014 matthew_shrago. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInputStream *inputStream;
NSOutputStream *outputStream;

@interface ViewController : UIViewController <NSStreamDelegate, UIApplicationDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>
- (IBAction)left_click:(id)sender;
- (IBAction)right_click:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *left_button;
@property (weak, nonatomic) IBOutlet UIButton *right_button;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)reload_Conn:(id)sender;
- (IBAction)type:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *hidden_text;
@property (weak, nonatomic) IBOutlet UIImageView *background_resign;

@end
