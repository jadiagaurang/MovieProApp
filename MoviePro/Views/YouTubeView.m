//
//  YouTubeView.m
//  MoviePro
//
//  Created by Gaurang Jadia on 3/17/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//
//  Help URLs:
//  http://apiblog.youtube.com/2009/02/youtube-apis-iphone-cool-mobile-apps.html
//  http://developer.apple.com/library/ios/#documentation/uikit/reference/UIWebView_Class/Reference/Reference.html
//

#import "YouTubeView.h"

@implementation YouTubeView
@synthesize webView;

- (YouTubeView *)initWithURL:(NSString *)ytid frame:(CGRect)frame {
	if (self = [super init]) {
		webView = [[UIWebView alloc] initWithFrame:frame];
		NSURL *url = [NSURL URLWithString:[@"http://m.youtube.com/watch?v=" stringByAppendingFormat:@"%@", ytid]];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		webView.scalesPageToFit = YES;
		[webView loadRequest:request];
	}
	return self;
}

- (YouTubeView *)initWithHTMLString:(NSString *)ytid frame:(CGRect)frame {
	if (self = [super init]) {
		webView = [[UIWebView alloc] initWithFrame:frame];
		
		NSString *htmlString = {
			@"<html>"
			@"<head>"
			@"<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=%d\" />"
			@"</head>"
			@"<body style=\"background:#000; margin-top:0px; margin-left:0px\">"
			@"<div>"
			@"<object width=\"%d\" height=\"%d\">"
			@"<param name=\"movie\" value=\"http://www.youtube.com/v/%@&f=gdata_videos&c=%@&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param>"
			@"<param name=\"wmode\" value=\"transparent\"></param>"
			@"<embed src=\"http://www.youtube.com/v/%@&f=gdata_videos&c=%@&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%d\" height=\"%d\"></embed>"
			@"</object>"
			@"</div>"
			@"</body>"
			@"</html>"
		};
		
		int w = frame.size.width;
		int h = frame.size.height;
		NSString *html = [@"" stringByAppendingFormat:htmlString, w, w, h, ytid, AppName, ytid, AppName, w, h];
		
		webView.scalesPageToFit = YES;
		[webView loadHTMLString:html baseURL:[NSURL URLWithString:[@"" stringByAppendingFormat:@"%@/", AppDomain]]];
	}
	return self;  
}
@end
