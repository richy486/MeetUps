//
//  MeetUpsGetter.m
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "ApiGetter.h"

@interface ApiGetter() {
    NSMutableData *_container;
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) ApiCompletionBlock completionBlock;
@end

@implementation ApiGetter

- (void) getMeetUpsUsingEndpoint:(NSString*) endpointString withCompletion:(ApiCompletionBlock) completion {
    if (endpointString) {
        
        self.completionBlock = completion;
        NSString *apiUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:API_URL_KEY];
        NSString *apiSigId = [[NSBundle mainBundle] objectForInfoDictionaryKey:API_SIG_ID_KEY];
        NSString *apiSig = [[NSBundle mainBundle] objectForInfoDictionaryKey:API_SIG_KEY];
        NSString *urlString = [NSString stringWithFormat:@"%@/%@&sig_id=%@&sig=%@", apiUrl, endpointString, apiSigId, apiSig];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _container = [[NSMutableData alloc] init];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

#pragma mark - URL Connection delegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_container appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (self.completionBlock) {
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:_container options:0 error:&error];
        if (error) {
            self.completionBlock(nil, error);
        } else {
            self.completionBlock(jsonObject, nil);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.completionBlock) {
        self.completionBlock(nil, error);
    }
}

@end
