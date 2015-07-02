//
//  Group.h
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *groupId;

// Extra
@property (nonatomic, strong) NSURL *photoUrl;

- (id) initWithDictionary:(NSDictionary*) dict;

@end
