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

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"eventDetailTitle", @"");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    if (self.event) {
        
        if (self.event.group.photoUrl) {
            [UIImage imageWithUrl:self.event.group.photoUrl complete:^(UIImage *image) {
                [self.headerImageView setImage:image];
            }];
        }
        
        self.titleLabel.text = self.event.name;
        self.groupNameLabel.text = self.event.group.name;
        
        NSError *error = nil;
        NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithData:[self.event.descriptionHtml dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:nil
                                                                                   error:&error];
        if (error) {
            NSLog(@"error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
        } else {
            self.descriptionLabel.attributedText = descriptionString;
        }
    }
}

    - (void) viewDidLayoutSubviews {
        [super viewDidLayoutSubviews];
        
        self.scrollViewWidthConstraint.constant = CGRectGetWidth(self.scrollView.frame);
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
