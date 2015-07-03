//
//  UIImage+LazyLoading.h
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (LazyLoading)

typedef void (^ImageLazyLoadingCompletionBlock)(UIImage *image);

+ (void) imageWithUrl:(NSURL*) imageUrl complete:(ImageLazyLoadingCompletionBlock) complete;

@end
