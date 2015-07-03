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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UITextView *descritionTextView;

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
        
        if (self.event.time) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            self.timeLabel.text = [dateFormatter stringFromDate:self.event.time];
        }
        
        self.venueLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"venue", @""), self.event.venueName];
        
        NSError *error = nil;
        
        NSString *modifiedHtml = [NSString stringWithFormat:@"<span style=\"font-family: HelveticaNeue; font-size: 15\">%@</span>", self.event.descriptionHtml];
        NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithData:[modifiedHtml dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:nil
                                                                                   error:&error];
        if (error) {
            NSLog(@"error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
        } else {
            [self.descritionTextView setAttributedText:descriptionString];
        }
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.imageViewWidthConstraint.constant = CGRectGetWidth(self.scrollView.frame);
    if (!self.event.group.photoUrl) {
        self.imageViewHeightConstraint.constant = 0;
    }
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
