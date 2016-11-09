/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  RemoteViewController.m
//  IoTstarter
//

#import "RemoteViewController.h"
#import "AppDelegate.h"

@interface RemoteViewController ()

@property (strong, nonatomic) IBOutlet UIButton *aButton;
@property (strong, nonatomic) IBOutlet UIButton *bButton;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (strong, nonatomic) IBOutlet UIButton *yButton;

@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation RemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int r = self.aButton.layer.frame.size.height;
    
    self.aButton.layer.cornerRadius = r/2;
    self.aButton.layer.borderWidth = 1;
    [self.aButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.bButton.layer.cornerRadius = r/2;
    self.bButton.layer.borderWidth = 1;
    [self.bButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.xButton.layer.cornerRadius = r/2;
    self.xButton.layer.borderWidth = 1;
    [self.xButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.yButton.layer.cornerRadius = r/2;
    self.yButton.layer.borderWidth = 1;
    [self.yButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    r = self.dpad.layer.frame.size.height;
    self.dpad.layer.cornerRadius = r/2;
    self.dpad.layer.borderWidth = 1;
    self.dpad.layer.masksToBounds = YES;
    self.dpad.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)directionPressed:(id)sender
{
    NSString *pressedString;
    if (sender == self.upButton)
    {
        NSLog(@"up pressed");
        pressedString = @"UP";
    }
    else if (sender == self.downButton)
    {
        NSLog(@"down pressed");
        pressedString = @"DOWN";
    }
    else if (sender == self.leftButton)
    {
        NSLog(@"left pressed");
        pressedString = @"LEFT";
    }
    else if (sender == self.rightButton)
    {
        NSLog(@"right pressed");
        pressedString = @"RIGHT";
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createGamepadMessage:pressedString];

    [appDelegate publishData:messageData event:IOTGamepadEvent];
}

- (IBAction)letterPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *pressedString;
    if ([button.titleLabel.text isEqualToString:@"A"])
    {
        NSLog(@"A pressed");
        pressedString = @"A";
    }
    else if ([button.titleLabel.text isEqualToString:@"B"])
    {
        NSLog(@"B pressed");
        pressedString = @"B";
    }
    else if ([button.titleLabel.text isEqualToString:@"X"])
    {
        NSLog(@"X pressed");
        pressedString = @"X";
    }
    else if ([button.titleLabel.text isEqualToString:@"Y"])
    {
        NSLog(@"Y pressed");
        pressedString = @"Y";
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createGamepadMessage:pressedString];

    [appDelegate publishData:messageData event:IOTGamepadEvent];
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLoginView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLogView];
}

@end
