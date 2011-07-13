//
//  Server.m
//  CouchDemo
//
//  Created by Arvind on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Server.h"


@implementation Server
static Server *_sharedInstance;

- (id) init
{
	if (self = [super init])
	{
		// custom initialization
		memset(board, 0, sizeof(board));
	}
	return self;
}

+ (Server *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[Server alloc] init];
	}
    
	return _sharedInstance;
}

- (NSString*) getFieldValueAtPos:(NSUInteger)x
{
	return board[x];
}

- (void) setFieldValueAtPos:(NSUInteger)x ToValue:(NSString *)newVal
{
	board[x] = newVal;
}

@end



//@synthesize servername;
//
//static NSString *_sharedInstance;
//
//-(id) init
//{
//    if (self == [super init]) {
//        memset(board, 0, sizeof(board));
//    }
//    return self;
//}
//
//+(NSString *)sharedInstance
//{
////    static Server *sharedInstance;
////    @synchronized(self){
////        if (!sharedInstance) {
////            sharedInstance = [[[Server alloc] init]retain];
////        }
////    }
////    return sharedInstance;
//        
//    if (!_sharedInstance) {
//       _sharedInstance = [[Server alloc] init];
//   }
//   
//   return _sharedInstance;
//}
//
//-(NSString *) getServerName
//{
//    return _sharedInstance;
//    //x=servername;
//    //return x;
//}
//
//-(void) setServerName:(NSString *)x
//{
//    _sharedInstance = x;
//    //servers[0] = x;
//    //servername = x;
//}
//@end
