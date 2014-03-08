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

@interface BoxOfficeController : UINavigationController <WebRequestDelegate, UITableViewDelegate, UITableViewDataSource> {
	UITableViewController *tvMovies;
	NSMutableArray *arrayMovies;
	BOOL _reloading;
}
@property(nonatomic, strong) UITableViewController *tvMovies;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
