//
//  SettingsController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 3/11/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "SettingsController.h"
#import "AppHelper.h"

@implementation SettingsController
@synthesize tvSettings, pvSettings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    //Do something here...
    }
    return self;
}

#pragma mark - View lifecycle
-(void)loadData {
	//We will bring data from the SQLite3 in the future...
	arrayCountry = [[NSMutableArray alloc] init];
	[arrayCountry addObject:@"US"];
	[arrayCountry addObject:@"UK"];
	[arrayCountry addObject:@"FR"];
	
	arrayResultCount = [[NSMutableArray alloc] init];
	[arrayResultCount addObject:@"10"];
	[arrayResultCount addObject:@"15"];
	[arrayResultCount addObject:@"20"];
}

- (void)loadView {
	[super loadView];
	
	tvSettings = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	tvSettings.tableView.delegate = self;
	tvSettings.tableView.dataSource = self;
	tvSettings.title = @"Settings";
	
	self.viewControllers = [NSArray arrayWithObject:tvSettings];
}

- (void)viewWillLayoutSubviews {
	tvSettings.tableView.frame = CGRectMake(10, 10, 300, 460);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self loadData];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - implimentation of methods for UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"General";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int intCount = 2;
	
	return intCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settings"];
		if([indexPath row] == 0) {
			cell.textLabel.text = @"Country";
			cell.detailTextLabel.text = [AppHelper getPlistData:@"settings" key:@"country"];
		}
		else if([indexPath row] == 1) {
			cell.textLabel.text = @"Result #";
			cell.detailTextLabel.text = [AppHelper getPlistData:@"settings" key:@"result"];
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	pvSettings = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 251, 320, 200)];
	pvSettings.delegate = self;
	pvSettings.dataSource = self;
	pvSettings.showsSelectionIndicator = YES;
	pvSettings.tag = [indexPath row];
	
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
	tvSettings.navigationItem.rightBarButtonItem = btnDone;
	
	[self.view addSubview:pvSettings];
}

- (void)doneClicked:(id *)sender {
	int row = [pvSettings selectedRowInComponent:0];
	NSIndexPath *cellpath = [NSIndexPath indexPathForRow:pvSettings.tag inSection:0];
	UITableViewCell *cell = (UITableViewCell *)[(UITableView *)tvSettings.view cellForRowAtIndexPath:cellpath];
	
	if(pvSettings.tag == 0) {
		[AppHelper setPlistData:@"settings" key:@"country" strValue:[arrayCountry objectAtIndex:row]];
		cell.detailTextLabel.text = [@"" stringByAppendingFormat:@"%@", [arrayCountry objectAtIndex:row]];
	}
	else if(pvSettings.tag == 1) {
		[AppHelper setPlistData:@"settings" key:@"result" strValue:[arrayResultCount objectAtIndex:row]];
		cell.detailTextLabel.text = [arrayResultCount objectAtIndex:row];
	}
	
	tvSettings.navigationItem.rightBarButtonItem = nil;
	[pvSettings removeFromSuperview];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	//
}

#pragma mark - implimentation of methods for UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
	//
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSUInteger intCount = 0;
	
	if(pickerView.tag == 0) {
		intCount = [arrayCountry count];
	}
	else if(pickerView.tag == 1) {
		intCount = [arrayResultCount count];
	}
	
	return intCount;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if(pickerView.tag == 0) {
		return [@"" stringByAppendingFormat:@"%@", [arrayCountry objectAtIndex:row]];
	}
	else if(pickerView.tag == 1) {
		return [@"" stringByAppendingFormat:@"%@", [arrayResultCount objectAtIndex:row]];
	}
	else {
		return @"";
	}
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 300;
	return sectionWidth;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end