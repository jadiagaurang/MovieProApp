//
//  MovieProfileController.h
//  MoviePro
//
//  Created by Gaurang Jadia on 2/26/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "MovieProfileController.h"
#import "QuartzCore/CALayer.h"
#import "AppHelper.h"
#import "PhotoGalleryController.h"
#import "VideoGalleryController.h"
#import "UIImageView+WebCache.h"

@interface MovieProfileController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
	Movie *movie;
	
	UIScrollView *vScroll;
	
	UIImageView *ivProfilePic;
	UITextView *txtTitle;
	
	UITableViewController *tvCast;
	
	UILabel *lReview;	
	UITextView *txtReview;
}

@property(nonatomic, strong)Movie *movie;

@property(nonatomic, strong)UIScrollView *vScroll;
@end