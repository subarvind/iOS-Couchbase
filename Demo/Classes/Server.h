//
//  Server.h
//  CouchDemo
//
//  Created by Arvind on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Server : NSObject {
    NSString *servername;
    NSString *servers[1];
}

@property (nonatomic, retain) NSString *servername;

+(Server *) sharedInstance;

-(NSString*) getServerName;

+(NSString *) thisisserver;

-(void) setServerName:(NSString *)x;
@end
