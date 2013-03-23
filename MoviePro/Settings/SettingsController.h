//
//  SettingsController.h
//  MoviePro
//
//  Created by Gaurang Jadia on 3/11/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UINavigationController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
	UITableViewController *tvSettings;
	UIPickerView *pvSettings;
	
	NSMutableArray *arrayCountry;
	NSMutableArray *arrayResultCount;
}
@property(nonatomic, strong) UITableViewController *tvSettings;
@property(nonatomic, strong) UIPickerView *pvSettings;
@end
