//
//  VideoGalleryController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 3/17/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "VideoGalleryController.h"

@implementation VideoGalleryController
@synthesize movie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil m:(Movie *)m {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		movie = m;
		[self.view addSubview:[AppHelper getActivityViewer:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
	}
	return self;
}

#pragma mark - App Lifecycle Methods
-(void)setupViews {
	tvClips = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvClips.tableView.delegate = self;
	tvClips.tableView.dataSource = self;
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	tvClips.refreshControl = refreshControl;
	
	//self.view = tvClips.view;
	[self.view addSubview:tvClips.view];
	[tvClips.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)loadView {
	[super loadView];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:@"clips" forKey:@"m"];
	[params setObject:movie.imdbid forKey:@"id"];
	WebRequest *r = [[WebRequest alloc] initWithURL:@"/index.php" parameters:params method:@"GET" delegate:self];
	[r load];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - implimentation of methods for UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Youtube";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int intCount = 0;
	if(movie != nil) {
		intCount = (int)[movie.clips count];
	}
	return intCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videogallery"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"videogallery"];
	}
	NSMutableDictionary *clip = [movie.clips objectAtIndex:[indexPath row]];
	cell.textLabel.text = [clip objectForKey:@"name"];
	cell.detailTextLabel.text = [clip objectForKey:@"size"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *clip = [movie.clips objectAtIndex:[indexPath row]];
	youTubeView = [[YouTubeView alloc] initWithHTMLString:[clip objectForKey:@"source"] frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:youTubeView.webView];
	
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = btnDone;
}

- (void) doneClicked:(id)sender {
	[UIView animateWithDuration:0.5
					  delay:0.25
					options: UIViewAnimationOptionCurveEaseOut 
				  animations:^{
					  youTubeView.webView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
				  } 
				  completion:^(BOOL finished){
					  self.navigationItem.rightBarButtonItem = nil;
					  [youTubeView removeFromSuperview];
					  youTubeView = nil;
				  }];
}

#pragma mark - WebRequest Delegate Methods
- (void)webrequestDidFinishLoading:(NSString *)response {
	[AppHelper stopActivityViewer:self.view];
	
	SBJsonParser *p = [[SBJsonParser alloc] init];
	NSError *nsError;
	NSMutableDictionary *dictMoviePhotos = [p objectWithString:response error:&nsError];
	
	if(!nsError){
		[movie setupClips:[dictMoviePhotos objectForKey:@"youtube"]];
		[self setupViews];
	}
}

-(void)webrequestDidFinishWithError:(NSString *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
