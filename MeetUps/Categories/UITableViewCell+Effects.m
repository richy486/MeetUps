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

@implementation UITableViewCell (LazyLoading)

- (void) setBackgroundImageWithUrl:(NSURL*) imageUrl {
    
    [UIImage imageWithUrl:imageUrl complete:^(UIImage *image) {
        [self setBackgroundImage:image];
    }];
}

- (void) setBackgroundImage:(UIImage*) image {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *processedImage = [image imageByApplyingColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        
        // Just get the section of the image that is shown
        CGImageRef imageRef = CGImageCreateWithImageInRect(processedImage.CGImage, self.bounds);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        CGFloat luminance = [croppedImage luminance];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundColor = [UIColor colorWithPatternImage:processedImage];

            if (luminance > 0.05) {
                self.textLabel.textColor = [UIColor whiteColor];
                self.detailTextLabel.textColor = [UIColor whiteColor];
                
            }
        });
    });
}


@end
