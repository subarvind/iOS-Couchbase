//
//  Server.m
//  CouchDemo
//
//  Created by Arvind on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Server.h"


@implementation Server
@synthesize servername;

static Server *_sharedInstance;

-(id) init
{
    if (self == [super init]) {
        memset(servers, 0, sizeof(servers));
    }
    return self;
}

+(Server *)sharedInstance
{
    static Server *sharedInstance;
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[Server alloc] init];
        }
    }
    return sharedInstance;
    
    //    if (!_sharedInstance) {
//        _sharedInstance = [[Server alloc] init];
//    }
//    
//    return _sharedInstance;
}

-(NSString *) getServerName
{
    //return server[0];
    return servername;
}

-(void) setServerName:(NSString *)x
{
    //servers[0] = x;
    servername = x;
}
@end
