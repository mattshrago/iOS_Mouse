//
//  ViewController.m
//  wireless_Mouse
//
//  Created by Matthew Shrago on 5/28/14.
//  Copyright (c) 2014 matthew_shrago. All rights reserved.
//

//when user looses connection with screen get coords from computer

#import "ViewController.h"

NSString *leftClick = @"Left_Click[click]", *rightClick = @"Right_Click[click]", *coordOfFinger;
NSString *ipAddress;
UInt32 portNum;
NSData *data;
UITouch *touchMove;
CGPoint touchLocation;
UITextField *ipText, *portText;
UIAlertView* dialog;

@interface ViewController ()
@end

@implementation ViewController
- (void)viewDidLoad
{
    dialog = [[UIAlertView alloc] init];
    [super viewDidLoad];
    [self lookAndFeel];
    data = [NSData alloc]; //Allocate memory for data to be passed to the server.
    
    [self network_conn]; //Open socket connection with client.
    [self initNetworkCommunication];
}
- (void)lookAndFeel{
    [_left_button.layer setMasksToBounds:YES];
    [_right_button.layer setMasksToBounds:YES];
    [self.toolbar setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new]forToolbarPosition:UIToolbarPositionAny];
    
    [self.left_button.layer setCornerRadius:10.0];
    [self.right_button.layer setCornerRadius:10.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)left_click:(id)sender {
    [self myOutStream:leftClick];
}

- (IBAction)right_click:(id)sender {
    [self myOutStream:rightClick];
}
- (void)myOutStream:(NSString *)whatToInput{
    data = [whatToInput dataUsingEncoding:NSASCIIStringEncoding];
    [outputStream write:[data bytes] maxLength:[data length]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchLocation = [touchMove locationInView:self.view];
    touchMove = [touches anyObject];
    
    //Formatting output to socket.
    coordOfFinger = [NSString stringWithFormat:@"%.f [pos] %.f [pos]", touchLocation.x, touchLocation.y];
        
    //Encoding data to be send out using "NSASCIIStringEncoding
    [self myOutStream:coordOfFinger];
}
- (IBAction)reload_Conn:(id)sender {
    [self network_conn];
}
- (IBAction)type:(id)sender {
    [self.hidden_text becomeFirstResponder];
}
- (void)network_conn {
    [dialog setDelegate:self];
     dialog.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [dialog setTitle:@"Server Address"];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"Connect"];
    
    
    ipText = [dialog textFieldAtIndex:0];
    ipText.placeholder = @"IP_Address";
    ipText.keyboardType = UIKeyboardTypeDecimalPad;
    
    portText  = [dialog textFieldAtIndex:1];
    portText.placeholder = @"Port_Num";
    portText.keyboardType = UIKeyboardTypeDecimalPad;
    
    [dialog show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)//OK button
    {
        [inputStream close];
        [outputStream close];
        [self initNetworkCommunication];
    }
    else
    {
        [self network_conn];
    }
}
- (void)initNetworkCommunication{
    CFWriteStreamRef writeStream;
    CFReadStreamRef readStream;

    int i = [portText.text intValue];
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ipText.text, i, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}
@end
