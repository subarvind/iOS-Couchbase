//
//  Server.h
//  CouchDemo
//
//  Created by Arvind on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Server : NSObject {
	NSUInteger board[100];  // c-style array
}

+ (Server *) sharedInstance;

- (NSString *) getFieldValueAtPos:(NSUInteger)x;
- (void) setFieldValueAtPos:(NSUInteger)x ToValue:(NSString *)newVal;

@end



//@class NewServerController;
//@class RootViewController;
//
//
//@interface Server : NSObject {
//    NSString *servername;
////    NSString *servers[1];
////    NSString *board[100];
//}
//
//@property (nonatomic, retain) NSString *servername;
//
//+(Server *) sharedInstance;
//
//-(NSString*) getServerName;
//
//+(NSString *) thisisserver;
//
//-(void) setServerName:(NSString *)x;
//@end
