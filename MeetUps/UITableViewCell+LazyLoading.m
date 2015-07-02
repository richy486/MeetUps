//
//  UITableViewCell+LazyLoading.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UITableViewCell+LazyLoading.h"

@implementation UITableViewCell (LazyLoading)

- (void) setBackgroundImageWithUrl:(NSURL*) imageUrl {
    
    NSString *filename = [imageUrl lastPathComponent];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:filename]]) {
        
        // If image is caches use that
        NSData *imageData = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:filename]];
        UIImage *image = [UIImage imageWithData:imageData];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                self.backgroundColor = [UIColor colorWithPatternImage:image];
            });
        });
    }
    
    
}


@end
