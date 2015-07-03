//
//  UIImage+LazyLoading.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UIImage+LazyLoading.h"

@implementation UIImage (LazyLoading)

+ (void) imageWithUrl:(NSURL*) imageUrl complete:(ImageLazyLoadingCompletionBlock) complete {
    NSString *filename = [imageUrl lastPathComponent];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:filename]]) {
        
        // If image is caches use that
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:filename]];
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete(image);
                }
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
                if (complete) {
                    complete(image);
                }
            });
        });
    }
}

@end
