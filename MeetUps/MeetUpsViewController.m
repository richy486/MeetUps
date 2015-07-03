//
//  ViewController.m
//  MeetUps
//
//  Created by Richard Adem on 1/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "MeetUpsViewController.h"
#import "OnboardingViewController.h"
#import "EventDetailViewController.h"
#import "ApiGetter.h"
#import "Event.h"
#import "Group.h"
#import "UITableViewCell+Effects.h"
#import <CoreLocation/CoreLocation.h>

NSString *const MEET_UPS_CELL_IDENTIFIER = @"meetUpsCell";

@interface MeetUpsViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    BOOL _shouldLoadDataOnAppear;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *events;
@end

@implementation MeetUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"eventsTitle", @"");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    _shouldLoadDataOnAppear = YES;
    [self hideErrorMessage];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(valueChanged_refreshControl:) forControlEvents:UIControlEventValueChanged];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Show the onboarding screen if this is the first time the app has run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasShownOnboarding = [defaults boolForKey:HAS_SHOWN_ONBOARDING_USER_DEFAULT_KEY];
    if (!hasShownOnboarding) {
        [self performSegueWithIdentifier:ONBOARDING_SEGUE_IDENTIFIER sender:self];
        
    } else if (_shouldLoadDataOnAppear) {
        _shouldLoadDataOnAppear = NO;
        
        // Show activity indicator when refreshing from code
        [self.activityIndicator startAnimating];
        [self getEventsForCurrentLocation];
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EVENT_DETAIL_SEGUE_IDENTIFIER]
        && [segue.destinationViewController respondsToSelector:@selector(setEvent:)]) {
        
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Event *event = self.events[indexPath.row];
        
        if (event) {
            [segue.destinationViewController setEvent:event];
        }
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void) unwindToContainerVC:(UIStoryboardSegue *)segue {
}

#pragma mark - Actions

- (void) valueChanged_refreshControl:(id) sender {
    [self getEventsForCurrentLocation];
}

#pragma mark -

- (void) getEventsForCurrentLocation {
    [self.refreshControl beginRefreshing];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        [self.locationManager startUpdatingLocation];
    } else {
        [self showErrorMessage:NSLocalizedString(@"errorMessageLocationAccess", @"")];
    }
}

- (void) showErrorMessage:(NSString*) errorMessage {
    
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
    
    [self.tableView setHidden:YES];
    [self.errorMessageLabel setHidden:NO];
    self.errorMessageLabel.text = errorMessage;
}
- (void) hideErrorMessage {
    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
    
    [self.tableView setHidden:NO];
    [self.errorMessageLabel setHidden:YES];
}

- (void) getMeetupsWithCoordinate:(CLLocationCoordinate2D) coordinate {
    NSString *latString = [NSString stringWithFormat:@"%.8f", coordinate.latitude];
    NSString *lngString = [NSString stringWithFormat:@"%.8f", coordinate.longitude];

    NSString *endpoint = [NSString stringWithFormat:@"2/open_events?and_text=False&offset=0&format=json"
                          "&limited_events=False&photo-host=public&page=20&radius=25.0&desc=False&status=upcoming"
                          "&fields=group_photos"
                          "&order=distance"
                          "&category=34"
                          "&lat=%@"
                          "&lon=%@"
                          
                          , latString
                          , lngString];
    

    ApiGetter *getter = [[ApiGetter alloc] init];
    [getter getUsingEndpoint:endpoint withCompletion:^(id jsonObject, NSError *error) {

        if (error || !jsonObject[@"results"]) {
            NSString *problem = jsonObject[@"problem"];
            if (problem && [problem.lowercaseString rangeOfString:@"throttled"].location != NSNotFound) {
                [self showErrorMessage:NSLocalizedString(@"errorMessageApiThrottled", @"")];
            } else {
                [self showErrorMessage:NSLocalizedString(@"errorMessageApiConnection", @"")];
            }
            
            if (error) {
                NSLog(@"error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
            } else {
                NSLog(@"error: %@", jsonObject);
            }
            
        } else {
            
            
            NSComparator distanceComparator = ^(Event *eventA, Event *eventB) {
                NSComparisonResult comparisonResult = [eventA.distance compare:eventB.distance];
                
                return comparisonResult;
            };

            // Put the json results into Event models
            NSArray *results = jsonObject[@"results"];
            NSMutableArray *events = [NSMutableArray arrayWithCapacity:results.count];
            for (NSDictionary *eventDict in results) {
                Event *event = [[Event alloc] initWithDictionary:eventDict];
                
                // Sort on insertion, api ordering is aproximate
                NSUInteger insertIndex = [events indexOfObject:event
                                                 inSortedRange:(NSRange){0, events.count}
                                                       options:NSBinarySearchingInsertionIndex
                                               usingComparator:distanceComparator];
                [events insertObject:event atIndex:insertIndex];
            }
            self.events = events;
            
            [self hideErrorMessage];
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.events) {
        return self.events.count;
    }
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MEET_UPS_CELL_IDENTIFIER];
    
    // Default style without image background
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];

    Event *event = self.events[indexPath.row];
    
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.group.name;
    
    if (event.group.photoUrl) {
        [cell setBackgroundImageWithUrl:event.group.photoUrl];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:EVENT_DETAIL_SEGUE_IDENTIFIER sender:self];
}

#pragma mark - CLLocation manager delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showErrorMessage:NSLocalizedString(@"errorMessageLocationConnection", @"")];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
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
