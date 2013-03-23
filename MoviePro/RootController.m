//
//  RootController.m
//  MoviePro
//
//  Created by Gaurang Jadia on 2/23/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "RootController.h"
#import "BoxOfficeController.h"
#import "SettingsController.h"

@implementation RootController

#pragma mark - Init Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    //UIViewController *vc1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
	    //vc1.title = @"Box Office";
	    //vc1.tabBarItem.image = [UIImage imageNamed:@"45-movie-1.png"];
	    //vc1.view.backgroundColor = [UIColor redColor];
	    
	    BoxOfficeController *pBoxOffice = [[BoxOfficeController alloc] initWithNibName:nil bundle:nil];
	    pBoxOffice.title = @"Box Office";
	    pBoxOffice.tabBarItem.image = [UIImage imageNamed:@"boxoffice.png"];
	    
	    UIViewController *vc2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
	    vc2.title = @"In Theater";
	    vc2.tabBarItem.image = [UIImage imageNamed:@"intheater.png"];
	    vc2.view.backgroundColor = [UIColor redColor];
	    
	    UIViewController *vc3 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
	    vc3.title = @"Search";
	    vc3.tabBarItem.image = [UIImage imageNamed:@"search.png"];
	    vc3.view.backgroundColor = [UIColor greenColor];
	    
	    SettingsController *vc4 = [[SettingsController alloc] initWithNibName:nil bundle:nil];
	    vc4.title = @"Settings";
	    vc4.tabBarItem.image = [UIImage imageNamed:@"seattings.png"];
	    
	    self.viewControllers = [NSArray arrayWithObjects:pBoxOffice, vc2, vc3, vc4, nil];
    }
    return self;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end
