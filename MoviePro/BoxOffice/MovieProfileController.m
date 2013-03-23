//
//  MovieProfileController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 2/26/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "BoxOfficeController.h"

#define tvDetailCellHeight 50.00
#define tvDetailHeaderHeight 30.00

@implementation MovieProfileController

@synthesize movie;
@synthesize vScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    //Do nothing here...
    }
    return self;
}

#pragma mark - View lifecycle
- (void)loadView {
	//Base view
	vScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	vScroll.contentSize = CGSizeMake(320, (150 + (tvDetailHeaderHeight * 3) + ((tvDetailCellHeight + 5) * ([movie.cast count] + 3))));
	vScroll.backgroundColor = [UIColor whiteColor];
	vScroll.delegate = self;
	
	ivProfilePic = [[UIImageView alloc] init];
	[ivProfilePic setImageWithURL:[NSURL URLWithString:[movie.posters objectAtIndex:1]]
		    placeholderImage:[UIImage imageNamed:@"MovieCellPlaceholder.png"] success:^(UIImage *image) {
			    //Do something here...
		    }
			failure:^(NSError *error) {
				//Do something here...
			}];
	
	ivProfilePic.layer.shadowColor = [UIColor blackColor].CGColor;
	ivProfilePic.layer.shadowOffset = CGSizeMake(0, 2);
	ivProfilePic.layer.shadowOpacity = 2;
	ivProfilePic.layer.shadowRadius = 2.0;
	
	txtTitle = [[UITextView alloc] init];
	txtTitle.editable = NO;
	txtTitle.backgroundColor = [UIColor clearColor];
	txtTitle.font = [UIFont fontWithName:AppFontBold size:18];
	txtTitle.text = [movie title];
	
	tvCast = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvCast.tableView.delegate = self;
	tvCast.tableView.dataSource = self;
	tvCast.tableView.backgroundColor = [UIColor clearColor];
	tvCast.tableView.opaque = NO;
	tvCast.tableView.backgroundView = nil;
	
	[vScroll addSubview:ivProfilePic];
	[vScroll addSubview:txtTitle];
	
	[vScroll addSubview:tvCast.tableView];
	
	self.view = vScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillLayoutSubviews {
	CGRect frame;
	
	frame = CGRectMake(10, 10, 90, 120);
	ivProfilePic.frame = frame;
	
	frame = CGRectMake(110, 10, 200, 60);
	txtTitle.frame = frame;
	
	frame = CGRectMake(5, 140, 310, ((tvDetailHeaderHeight * 3) + ((tvDetailCellHeight + 5) * ([movie.cast count] + 3))));
	tvCast.tableView.frame = frame;
}

#pragma mark - implimentation of methods for UITableViewDelegate / UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tvDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return tvDetailHeaderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return @"Synopsis";
	}
	else	if(section == 1) {
		return @"Media";
	}
	else if(section == 2) {
		return @"Cast";		
	}
	else if(section == 3) {
		return @"MPAA Ratings";
	}
	else {
		return @"";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int intCount = 0;
	
	if(section == 0) {
		intCount = 1;
	}
	else if (section == 1) {
		intCount = 2;
	}
	else if (section == 2) {
		if(movie.cast) {
			intCount = [movie.cast count];
		}		
	}
	else if (section == 3) {
		intCount = 1;
	}
	//NSLog(@"section %d, row %d", section, intCount);
	return intCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMovieProfile"];
	NSInteger section = [indexPath section];
	
	if(section == 0) {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellMovieProfile"];
			cell.textLabel.text = [movie synopsis];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	else if(section == 1) {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellMovieProfile"];
			if([indexPath row] == 0) {
				cell.textLabel.text = @"Photos";	
			}
			else {
				cell.textLabel.text = @"Clips";
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	else if(section == 2) {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellMovieProfile"];
			NSMutableDictionary *actor = [movie.cast objectAtIndex:indexPath.row];
			cell.textLabel.text = [actor objectForKey:@"name"];
			NSMutableArray *character = [actor objectForKey:@"characters"];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"as %@", [character objectAtIndex:0]];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if(section == 3) {
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellMovieProfile"];
			cell.textLabel.text = @"MPAA";
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1 && indexPath.row == 0) {
		PhotoGalleryController *selectedMoviePhotoGallery = [[PhotoGalleryController alloc] initWithNibName:nil bundle:nil m:movie];
		selectedMoviePhotoGallery.title = @"Photos";
		
		[self.navigationController pushViewController:selectedMoviePhotoGallery animated:YES];
	}
	else if(indexPath.section == 1 && indexPath.row == 1) {
		VideoGalleryController *selectedMovieVideoGallery = [[VideoGalleryController alloc] initWithNibName:nil bundle:nil m:movie];
		selectedMovieVideoGallery.title = @"Clips";
		
		[self.navigationController pushViewController:selectedMovieVideoGallery animated:YES];
	}
	else {
		//Do something here...
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end