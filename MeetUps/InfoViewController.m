//
//  InfoViewController.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doneButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)touchUpIn_doneButton:(id)sender {
    [self performSegueWithIdentifier:UNWIND_TO_MEETUPS_IDENTIFIER sender:self];
    
}
- (IBAction)touchUpIn_webButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://richardadem.com"]];
}

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
