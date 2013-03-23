//
//  BoxOfficeController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 2/24/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "BoxOfficeController.h"

#define tvDefaultCellHeight 100.00

@implementation BoxOfficeController
@synthesize tvMovies;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    [self.view addSubview:[AppHelper getActivityViewer:self.view.frame]];
    }
    return self;
}

#pragma mark - App Lifecycle Methods
- (void)setAllView {
	//Setup TableViewController as Main Controller
	//CGRect appRootFrame = [[UIScreen mainScreen] applicationFrame];
	//CGRect appFrame = CGRectMake(0, 0, appRootFrame.size.width, appRootFrame.size.height);
	
	tvMovies = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	tvMovies.tableView.delegate = self;
	tvMovies.tableView.dataSource = self;
	
	//[self.view addSubview:tvMovies.tableView];
	//[self.navigationController pushViewController:tvMovies animated:NO];
	self.viewControllers = [NSArray arrayWithObject:tvMovies];
	
	//Navigation Bar Title
	tvMovies.title = @"Box Office";
	
	if (_refreshHeaderView == nil) {	
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tvMovies.tableView.bounds.size.height, tvMovies.view.frame.size.width, tvMovies.tableView.bounds.size.height)];
		view.delegate = self;
		[tvMovies.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)reload {
	//Do something here...
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:@"boxoffice" forKey:@"m"];
	[params setObject:[AppHelper getPlistData:@"settings" key:@"country"] forKey:@"c"];
	[params setObject:[AppHelper getPlistData:@"settings" key:@"result"] forKey:@"l"];
	WebRequest *r = [[WebRequest alloc] initWithURL:@"/moviepro/index.php" parameters:params method:@"POST" delegate:self];
	[r load];
	//[r loadAsync];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - implimentation of methods for UITableViewDelegate / UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tvDefaultCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [AppHelper getPlistData:@"settings" key:@"country"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int intCount = 0;
	if(arrayMovies) {
		intCount = [arrayMovies count];
	}
	return intCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"movie-%d", indexPath.row]];
	if (cell == nil) {
		Movie *objMovie = [arrayMovies objectAtIndex:indexPath.row];
		cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"movie-%d", indexPath.row] movie:objMovie rowNumber:indexPath.row];
		
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Movie *objMovie = [arrayMovies objectAtIndex:indexPath.row];
	
	MovieProfileController *selectedMovie = [[MovieProfileController alloc] initWithNibName:nil bundle:nil];
	selectedMovie.movie = objMovie;
	selectedMovie.title = @"Details";
	
	[self pushViewController:selectedMovie animated:YES];
}

#pragma mark - WebRequest Delegate Methods
- (void)webrequestDidFinishLoading:(NSString *)response {
	[AppHelper stopActivityViewer:self.view];
	
	SBJsonParser *p = [[SBJsonParser alloc] init];
	NSError *nsError;
	NSDictionary *dictMovies = [p objectWithString:response error:&nsError];
	
	if(!nsError){
		if(arrayMovies == nil) {
			arrayMovies = [[NSMutableArray alloc] init];
		}
		else {
			[arrayMovies removeAllObjects];
		}
		
		NSMutableArray *movies = [dictMovies objectForKey:@"movies"];
		for (NSMutableDictionary *movie in movies) {
			[arrayMovies addObject:[[Movie alloc] initWithObject:movie]];
		}
		
		if(_reloading) {
			[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
		}
		else {
			[self setAllView];			
		}
	}
}

-(void)webrequestDidFinishWithError:(NSString *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//Do something here...
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource {
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tvMovies.tableView];
	[tvMovies.tableView reloadData];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:@"boxoffice" forKey:@"m"];
	[params setObject:[AppHelper getPlistData:@"settings" key:@"country"] forKey:@"c"];
	[params setObject:[AppHelper getPlistData:@"settings" key:@"result"] forKey:@"l"];
	WebRequest *r = [[WebRequest alloc] initWithURL:@"/moviepro/index.php" parameters:params method:@"POST" delegate:self];
	[r load];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end