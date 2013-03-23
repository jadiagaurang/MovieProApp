//
//  BoxOfficeController.h
//  MoviePro
//
//  Created by Gaurang Jadia on 2/24/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "WebRequest.h"
#import "SBJson.h"
#import "AppHelper.h"
#import "MovieCell.h"
#import "MovieProfileController.h"
#import "EGORefreshTableHeaderView.h"

@interface BoxOfficeController : UINavigationController <EGORefreshTableHeaderDelegate, WebRequestDelegate, UITableViewDelegate, UITableViewDataSource>
{
	UITableViewController *tvMovies;
	NSMutableArray *arrayMovies;
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}
@property(nonatomic, strong) UITableViewController *tvMovies;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
