//
//  MeetUpsGetter.h
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiGetter : NSObject

typedef void (^ApiCompletionBlock)(NSString *result, NSError *error);

- (void) getMeetUpsUsingEndpoint:(NSString*) endpointString withCompletion:(ApiCompletionBlock) completion;

@end
