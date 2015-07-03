//
//  EventDetailViewController.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Event.h"
#import "Group.h"
#import "UIImage+LazyLoading.h"

NSString *const EVENT_DETAIL_CELL_IDENTIFIER = @"eventDetailCell";

@interface EventDetailViewController () <UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"eventDetailTitle", @"");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    if (self.event && self.event.group.photoUrl) {
        [UIImage imageWithUrl:self.event.group.photoUrl complete:^(UIImage *image) {
            [self.headerImageView setImage:image];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.event) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVENT_DETAIL_CELL_IDENTIFIER];
    
    cell.textLabel.text = self.event.name;
    cell.detailTextLabel.text = self.event.group.name;
    
    
    
    return cell;
}

#pragma mark - Table view delegate



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
