//
//  VideoGalleryController.h
//  MoviePro
//
//  Created by Gaurang Jadia on 3/17/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "SBJsonParser.h"
#import "WebRequest.h"
#import "AppHelper.h"
#import "YouTubeView.h"

@interface VideoGalleryController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
	Movie *movie;
	UITableViewController *tvClips;
	YouTubeView *youTubeView;
}

@property(nonatomic, strong)Movie *movie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil m:(Movie *)m;
@end
