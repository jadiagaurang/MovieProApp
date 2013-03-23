//
//  YouTubeView.h
//  MoviePro
//
//  Created by Gaurang Jadia on 3/17/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeView : UIView
{
	UIWebView *webView;
}
@property(nonatomic, strong) UIWebView *webView;

- (YouTubeView *)initWithURL:(NSString *)ytid frame:(CGRect)frame;
- (YouTubeView *)initWithHTMLString:(NSString *)ytid frame:(CGRect)frame;
@end
