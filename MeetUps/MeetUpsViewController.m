//
//  ViewController.m
//  MeetUps
//
//  Created by Richard Adem on 1/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "MeetUpsViewController.h"
#import "OnboardingViewController.h"
#import "ApiGetter.h"
#import <CoreLocation/CoreLocation.h>

NSString *const MEET_UPS_CELL_IDENTIFIER = @"meetUpsCell";

@interface MeetUpsViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) ApiGetter *getter;
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
    BOOL hasShownOnboarding = [defaults boolForKey:HAS_SHOWN_ONBOARDING_USER_DEFAULT_KEY];
    if (!hasShownOnboarding) {
        [self performSegueWithIdentifier:ONBOARDING_SEGUE_IDENTIFIER sender:self];
        [defaults setBool:YES forKey:HAS_SHOWN_ONBOARDING_USER_DEFAULT_KEY];
        [defaults synchronize];
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {

            if (!self.locationManager) {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                [self.locationManager startUpdatingLocation];
            }
        } else {
            [self showErrorMessage:NSLocalizedString(@"errorMessageLocationAccess", @"")];
        }
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (IBAction)unwindToContainerVC:(UIStoryboardSegue *)segue {
}

#pragma mark - 

- (void) showErrorMessage:(NSString*) errorMessage {
    [self.tableView setHidden:YES];
    self.errorMessageLabel.text = errorMessage;
}
- (void) hideErrorMessage {
    [self.tableView setHidden:NO];
}

- (void) getMeetupsWithCoordinate:(CLLocationCoordinate2D) coordinate {
    NSString *latString = [NSString stringWithFormat:@"%.8f", coordinate.latitude];
    NSString *lngString = [NSString stringWithFormat:@"%.8f", coordinate.longitude];

    if (!self.getter) {
        self.getter = [[ApiGetter alloc] init];
    }
    
    NSString *endpoint = [NSString stringWithFormat:@"2/open_events?and_text=False&offset=0&format=json"
                          "&lat=%@"
                          "&lon=%@"
                          "&limited_events=False&photo-host=public&page=20&radius=25.0&desc=False&status=upcoming"
                          , latString
                          , lngString];
    

    [self.getter getMeetUpsUsingEndpoint:endpoint withCompletion:^(NSString *result, NSError *error) {
        NSLog(@"result: %@", result);
        
    }];
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

#pragma mark - CLLocation manager delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showErrorMessage:NSLocalizedString(@"errorMessageLocationConnection", @"")];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;

    if (currentLocation != nil) {
        [manager stopUpdatingLocation];
        [self getMeetupsWithCoordinate:currentLocation.coordinate];
        
    }
}

#pragma mark - Memory manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
