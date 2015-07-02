//
//  ViewController.m
//  MeetUps
//
//  Created by Richard Adem on 1/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "MeetUpsViewController.h"
#import "OnboardingViewController.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

NSString *const MEET_UPS_CELL_IDENTIFIER = @"meetUpsCell";

@interface MeetUpsViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;


@property (nonatomic, strong) NSArray *meetUps;
@end

@implementation MeetUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // TODO: replace this with first run check
//    if ([[LocationManager sharedInstance] isAuthorized]) {
//        // TODO: get location
//    } else {
//        [self performSegueWithIdentifier:ONBOARDING_SEGUE_IDENTIFIER sender:self];
//    }
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Show the onboarding screen if this is the first time the app has run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownOnboarding = [defaults boolForKey:HAS_SHOWN_ONBOARDING_USER_DEFAULT];
    if (!hasShownOnboarding) {
        [self performSegueWithIdentifier:ONBOARDING_SEGUE_IDENTIFIER sender:self];
        [defaults setBool:YES forKey:HAS_SHOWN_ONBOARDING_USER_DEFAULT];
        [defaults synchronize];
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            // TODO: get location
        } else {
            [self showErrorMessage:NSLocalizedString(@"errorMessageLocationAccess", @"")];
        }
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (IBAction)unwindToContainerVC:(UIStoryboardSegue *)segue {
    NSLog(@"unwinded");
}

#pragma mark - 

- (void) showErrorMessage:(NSString*) errorMessage {
    [self.tableView setHidden:YES];
    self.errorMessageLabel.text = errorMessage;
}
- (void) hideErrorMessage {
    [self.tableView setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.meetUps) {
        return self.meetUps.count;
    }
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MEET_UPS_CELL_IDENTIFIER];
    return cell;
}

#pragma mark - Table view delegate

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
