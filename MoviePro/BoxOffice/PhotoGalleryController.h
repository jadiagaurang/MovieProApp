//
//  PhotoGalleryController.h
//  MoviePro
//
//  Created by Gaurang Jadia on 3/13/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Movie.h"
#import "AppHelper.h"
#import "WebRequest.h"
#import "SBJsonParser.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface PhotoGalleryController : UIViewController<WebRequestDelegate, UIScrollViewDelegate> {
	Movie *movie;
	
	UIScrollView *vScroll;
	UIScrollView *scrollView;
}

@property(nonatomic, strong)Movie *movie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil m:(Movie *)m;
@end