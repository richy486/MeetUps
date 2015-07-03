//
//  UITableViewCell+Effects.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UITableViewCell+Effects.h"
#import "UIImage+LazyLoading.h"
#import "UIImage+Color.h"
#import "UIImage+Alpha.h"

@implementation UITableViewCell (LazyLoading)

- (void) setBackgroundImageWithUrl:(NSURL*) imageUrl {
    
    [UIImage imageWithUrl:imageUrl complete:^(UIImage *image) {
        [self setBackgroundImage:image];
    }];
}

- (void) setBackgroundImage:(UIImage*) image {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *semiTransparentImage = [image imageByApplyingAlpha:0.75];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [UIColor colorWithPatternImage:semiTransparentImage];
        });
    });
    
    CGFloat luminance = [image luminance];
    if (luminance > 0.5) {
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textColor = [UIColor blackColor];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
    }
}


@end
