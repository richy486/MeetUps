//
//  MeetUp.h
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;

@interface Event : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Group *group;

- (id) initWithDictionary:(NSDictionary*) dict;

@end
