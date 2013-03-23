//
//  WebRequest.h
//  MoviePro
//
//  Created by Gaurang Jadia on 2/24/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppHelper.h"
#import "SBJson.h"

@protocol WebRequestDelegate <NSObject>

@required
- (void) webrequestDidFinishLoading: (NSString *)response;
- (void) webrequestDidFinishWithError: (NSString *) reason;
@end

@interface WebRequest : NSObject {
	id <WebRequestDelegate> _delegate;
	
	NSMutableData *responseData;
	NSMutableURLRequest *request;
	//NSURLRequest *request;
	NSURLConnection *connection;
}

@property (nonatomic, strong) id delegate;

- (id)initWithURL:(NSString *)link parameters:(NSMutableDictionary *)parameters method:(NSString *)method delegate:(id)delegate;
- (void)load;
- (void)loadAsync;

-(NSString *)getParameters:(NSMutableDictionary *)parameters;
@end
