//
//  UIImage+AverageColor.m
//  MeetUps
//
//  Created by Richard Adem on 3/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (AverageColor)

- (UIColor*) averageColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

- (CGFloat) luminance {
    UIColor *averageColor = [self averageColor];
    
    CGFloat red, green, blue, alpha = 0;
    [averageColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat luminance = red*0.299 + green*0.587 + blue*0.114;
    
    return luminance;
}

- (UIImage*) imageByApplyingColor:(UIColor *)color {
    
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -imageRect.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, imageRect, self.CGImage);
    
    [color set];
    CGContextFillRect(context, imageRect);
    
    CGContextRestoreGState(context);
    
    // alpha
    CGFloat white, alpha;
    [color getWhite:&white alpha:&alpha];

    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, imageRect, self.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
