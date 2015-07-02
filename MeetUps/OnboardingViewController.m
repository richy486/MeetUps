//
//  OnboardingViewController.m
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "OnboardingViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface OnboardingViewController() <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descriptionLabel.text = NSLocalizedString(@"onboardingDescription", @"");
    [self.continueButton setTitle:NSLocalizedString(@"onboardingContinueButton", @"") forState:UIControlStateNormal];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

#pragma mark - Actions

- (IBAction)touchUpIn_continueButton:(UIButton*) button {
    
    // Check if the app has been authorized already, e.g. from iOS Settings
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self performSegueWithIdentifier:UNWIND_TO_MEETUPS_IDENTIFIER sender:self];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocation manager delegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // Close if anything but not determined
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSegueWithIdentifier:UNWIND_TO_MEETUPS_IDENTIFIER sender:self];
    }
}

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
