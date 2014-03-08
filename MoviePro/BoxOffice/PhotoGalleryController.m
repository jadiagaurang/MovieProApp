//
//  PhotoGalleryController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 3/13/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "PhotoGalleryController.h"

@implementation PhotoGalleryController
@synthesize movie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil m:(Movie *)m
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    movie = m;
	    [self.view addSubview:[AppHelper getActivityViewer:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
    }
    return self;
}

#pragma mark - App Lifecycle Methods
-(void)setupViews {
	vScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	vScroll.contentSize = CGSizeMake(320, (ceil((double)[movie.photos count] / 4) * 74) + (5 * ceil((double)[movie.photos count] / 4)));
	vScroll.backgroundColor = [UIColor whiteColor];
	vScroll.delegate = self;
	
	for (int i = 0; i < [movie.photos count]; i++) {
		UIButton *btnThumb = [UIButton buttonWithType:UIButtonTypeCustom];
		btnThumb.frame = CGRectMake(5 + (5 * (i % 4)) + (74 * (i % 4)), 5 + (5 * (i / 4)) + (74 * (i / 4)), 74, 74);
		
		UIImageView *picThumb = [[UIImageView alloc] init];
		[picThumb setImageWithURL:[NSURL URLWithString:[[movie.photos objectAtIndex:i] objectForKey:@"thumbnail"]]
			    placeholderImage:[UIImage imageNamed:@"MovieCellPlaceholder.png"] success:^(UIImage *image) {
				    //Do something here...
			    }
			    failure:^(NSError *error) {
				    //Do something here...
			    }];
		picThumb.frame = CGRectMake(0, 0, 74, 74);
		[picThumb.layer setBorderColor: [[UIColor blackColor] CGColor]];
		[picThumb.layer setBorderWidth: 1.0];
		btnThumb.tag = i;
		[btnThumb addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btnThumb addSubview:picThumb];
		
		[vScroll addSubview:btnThumb];
	}
	
	//self.view = vScroll;
	[self.view addSubview:vScroll];
}

- (void)loadView {
	[super loadView];
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:@"photos3" forKey:@"m"];
	[params setObject:movie.imdbid forKey:@"id"];
	WebRequest *r = [[WebRequest alloc] initWithURL:@"/index.php" parameters:params method:@"GET" delegate:self];
	[r load];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - Gallery
- (void) imageClicked:(id)sender {
	UIButton *btnThumb = sender;
	
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollsToTop = NO;
	scrollView.delegate = self;
	scrollView.contentSize = CGSizeMake(320 * ([movie.photos count]), 460);
	scrollView.backgroundColor = [UIColor blackColor];
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
	doubleTap.numberOfTapsRequired = 1;
	[scrollView addGestureRecognizer:doubleTap];
	
	[self.view addSubview:scrollView];
	
	int index = 0;
	for (int i = 0; i < [movie.photos count]; i++)  {	
		UIImageView *picDetail = [[UIImageView alloc] init];
		[picDetail setImageWithURL:[NSURL URLWithString:[[movie.photos objectAtIndex:i] objectForKey:@"original"]] placeholderImage:[UIImage imageNamed:@"PhotoGalleryPlaceholder.png"]
					    success:^(UIImage *image) {
						    //Do something here...
					    }
					    failure:^(NSError *error) {
						    //Do something here...
					    }];
		picDetail.frame = CGRectMake(index, 0, 320, 400);
		index = index + 320;
		picDetail.contentMode = UIViewContentModeScaleAspectFit;
		
		[scrollView addSubview:picDetail];
	}
	
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
	self.navigationItem.rightBarButtonItem = btnDone;
	
	[UIView animateWithDuration:0.25
					  delay:0.0
					options: UIViewAnimationOptionCurveEaseOut 
				  animations:^{
					  [self.navigationController setNavigationBarHidden:YES animated:YES];
					  [self.tabBarController.tabBar setFrame:CGRectMake(self.tabBarController.tabBar.frame.origin.x, 480, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
				  }
				  completion:^(BOOL finished){
					  //
				  }];
	
	[scrollView scrollRectToVisible:CGRectMake(320 * btnThumb.tag, 0, 320 , 460) animated:NO];
}

- (void) doneClicked:(id)sender {
	[UIView animateWithDuration:0.5
					  delay:0.25
					options: UIViewAnimationOptionCurveEaseOut
				  animations:^{
					  scrollView.frame = CGRectMake(0, 400, 320, 400);
				  } 
				  completion:^(BOOL finished){
					  self.navigationItem.rightBarButtonItem = nil;
					  [scrollView removeFromSuperview];
					  scrollView = nil;
				  }];
}

- (void)handleDoubleTap {
	[UIView animateWithDuration:0.25
					  delay:0.0
					options: UIViewAnimationOptionCurveEaseOut 
				  animations:^{
					  [self.navigationController setNavigationBarHidden:NO animated:YES];
					  [self.tabBarController.tabBar setFrame:CGRectMake(self.tabBarController.tabBar.frame.origin.x, 431.000000, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height)];
				  }
				  completion:^(BOOL finished){
					  scrollView.frame = CGRectMake(0, 0, 320, 400);
					  scrollView.contentSize = CGSizeMake(320 * ([movie.photos count]), 460);
				  }];
}

#pragma mark - WebRequest Delegate Methods
- (void)webrequestDidFinishLoading:(NSString *)response {
	[AppHelper stopActivityViewer:self.view];
	
	SBJsonParser *p = [[SBJsonParser alloc] init];
	NSError *nsError;
	NSMutableDictionary *dMoviePhotos = [p objectWithString:response error:&nsError];
	
	if(!nsError){
		[movie setupPhotos:[dMoviePhotos objectForKey:@"backdrops"]];
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