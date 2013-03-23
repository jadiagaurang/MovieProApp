//
//  AppDelegate.h
//  MoviePro
//
//  Created by Gaurang Jadia on 2/23/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	RootController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootController *tabBarController;
@end
