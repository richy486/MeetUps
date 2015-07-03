//
//  UIImage+AverageColor.h
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (AverageColor)

- (UIColor*) averageColor;
- (CGFloat) luminance;
- (UIImage*) imageByApplyingColor:(UIColor *)color;

@end
