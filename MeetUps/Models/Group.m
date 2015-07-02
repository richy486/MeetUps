//
//  Group.m
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "Group.h"

@implementation Group

- (id) initWithDictionary:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.groupId = dict[@"id"];

    }
    return self;
}

@end
