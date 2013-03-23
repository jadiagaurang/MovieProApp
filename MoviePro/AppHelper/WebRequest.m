//
//  WebRequest.m
//  MoviePro
//
//  Created by Gaurang Jadia on 2/24/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "WebRequest.h"

@implementation WebRequest
@synthesize delegate = _delegate;

- (id)initWithURL:(NSString *)link parameters:(NSMutableDictionary *)parameters method:(NSString *)method delegate:(id)delegate {
	self = [super init];
	if (self) {
		_delegate = delegate;
		
		responseData = [NSMutableData data];
		request = [[NSMutableURLRequest alloc] init];
		
		if([method length] != 0 && [method isEqualToString:@"POST"]) {
			[request setURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", AppDomain, link]]];
			[request setHTTPMethod:method];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[request setHTTPBody:[[self getParameters:parameters] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
		}
		else {
			[request setURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?%@", AppDomain, link, [self getParameters:parameters]]]];
			[request setHTTPMethod:@"GET"];
		}
		

		[request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
		[request setTimeoutInterval:60.0];
	}
	return self;
}

- (void)load {
	if([AppHelper checkNetworkStatus]) {
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else {
		[[self delegate] webrequestDidFinishWithError:@"Mobile Network Unavailable"];
	}
}

- (void)loadAsync {
	if([AppHelper checkNetworkStatus]) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		NSError *error = nil;
		NSURLResponse *response = nil;
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		NSData *asyncResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if (error) {
		}
		else {
			NSString *strResponse = [[NSString alloc] initWithData:asyncResponseData encoding:NSUTF8StringEncoding];
			strResponse = [strResponse stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[[self delegate] webrequestDidFinishLoading:strResponse];
		}
	}
	else {
		[[self delegate] webrequestDidFinishWithError:@"Mobile Network Unavailable"];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	@try {
		[responseData appendData:data];
	}
	@catch (NSException *ex) {
		[[self delegate] webrequestDidFinishWithError:ex.name];
	}
	@finally {
		//Do something here...
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString *strResponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	strResponse = [strResponse stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	[[self delegate] webrequestDidFinishLoading:strResponse];
}

-(NSString *)_getParameters:(NSMutableDictionary *)parameters {
	NSString *strParameters = @"";
	for (NSString* key in parameters) {
		strParameters = [strParameters stringByAppendingFormat:@"%@=%@&", key, [parameters objectForKey:key]];
	}
	strParameters = [strParameters substringToIndex:([strParameters length] - 1)];
	return strParameters;
}

-(NSString *)getParameters:(NSMutableDictionary *)parameters {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in parameters) {
		id value = [parameters objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", [AppHelper urlEncode:key], [AppHelper urlEncode:value]];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}
@end