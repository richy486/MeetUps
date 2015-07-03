//
//  UITableViewCell+LazyLoading.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UITableViewCell+LazyLoading.h"
#import "UIImage+Color.h"
#import "UIImage+Alpha.h"

@implementation UITableViewCell (LazyLoading)

- (void) setBackgroundImageWithUrl:(NSURL*) imageUrl {
    
    NSString *filename = [imageUrl lastPathComponent];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:filename]]) {
        
        // If image is caches use that
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:filename]];
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBackgroundImage:image];
            });
        });
    } else {
        
        // If the image is not found in the cache download it
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
            
            // Cache the image
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSError *error = nil;
                [imageData writeToFile:[path stringByAppendingPathComponent:filename] options:NSDataWritingAtomic error:&error];
                if (error) {
                    NSLog(@"error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
                }
            });
            
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBackgroundImage:image];
            });
        });
    }
}

- (void) setBackgroundImage:(UIImage*) image {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *semiTransparentImage = [image imageByApplyingAlpha:0.75];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [UIColor colorWithPatternImage:semiTransparentImage];
        });
    });
//    self.backgroundColor = [UIColor colorWithPatternImage:image];
    
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
