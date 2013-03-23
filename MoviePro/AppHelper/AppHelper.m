//
//  AppHelper.m
//  Homework5
//
//  Created by Gaurang Jadia on 2/14/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

#pragma mark - App Lifecycle
+(BOOL) checkNetworkStatus {
	Reachability* reachability = [Reachability reachabilityWithHostName:@"code.gaurangjadia.com"];
	NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
	
	BOOL isAvailable = NO;
	if(remoteHostStatus == NotReachable) {
		isAvailable = NO;
	}
	else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) { 
		isAvailable = YES;
	}
	
	return isAvailable;
}

+(UIActivityIndicatorView *)getActivityViewer:(CGRect) frame {
	UIActivityIndicatorView *pointerActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	pointerActivity.frame = frame;
	pointerActivity.opaque = YES;
	pointerActivity.backgroundColor = [UIColor lightGrayColor];
	pointerActivity.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
	pointerActivity.hidesWhenStopped = YES;
	[pointerActivity startAnimating];
	
	return pointerActivity;
}

+(void)stopActivityViewer:(UIView *)viewOwner {
	for (UIView *view in [viewOwner subviews])  {
		if([view class] == [UIActivityIndicatorView class]) {
			UIActivityIndicatorView *a = (UIActivityIndicatorView *)view; 
			if([a isAnimating]) {
				[a stopAnimating];
			}
			[view removeFromSuperview];
		}
	}
}

#pragma mark - Utility Methods
+(NSDate *)getDateByString:(NSString *)date formatter:(NSString *)formatter {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatter];
	NSDate *dateFromString = [[NSDate alloc] init];
	dateFromString = [dateFormatter dateFromString:date];
	return dateFromString;
}

+(NSString *)getStringByDate:(NSDate *)date formatter:(NSString *)formatter {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatter];
	NSString *strDate = [dateFormatter stringFromDate:date];
	return strDate;
}

+(UIColor *) getColorByHex:(int) c {
	//https://discussions.apple.com/message/7835360?messageID=7835360#7835360?messageID=7835360
	return [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];
}

+(BOOL) isFontExist:(NSString *) argFontName {
	BOOL isFontExist = NO;
	for( NSString *familyName in [UIFont familyNames] ) {
		for( NSString *fontName in [UIFont fontNamesForFamilyName:familyName] ) {
			if([fontName isEqualToString:argFontName]) {
				isFontExist = YES;
				break;
			}
		}
	}
	return isFontExist;
}

#pragma mark - Device Methods
+(BOOL)isIPhone {
	return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

#pragma mark - FileSystem Methods
+(BOOL)isFileExist:(NSString *)strFileName {
	NSString *filepath = [self getFilePathFromDocs:strFileName];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
	return fileExists;
}

+(NSString *)getDocsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	return documentsDirectory;
}

+(NSString *)getFilePathFromDocs:(NSString*)filename {
	NSString *result = [[AppHelper getDocsDirectory] stringByAppendingPathComponent:filename];
	return result;
}

+(BOOL)setPlist:(NSString *)strPlistName {
	NSError *error;
	NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:path]) {
		NSString *bundle = [[NSBundle mainBundle] pathForResource:strPlistName ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath:path error:&error];
		return YES;
	}
	else {
		return NO;
	}
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue {
	[self setPlist:strPlistName];
	
	NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
	NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	[data setObject:strValue forKey:key];
	//[data setObject:[NSNumber numberWithInt:strValue] forKey:key];

	[data writeToFile:path atomically:YES];
}

+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key {
	[self setPlist:strPlistName];
	
	NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
	NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
	return [data objectForKey:key];
}

#pragma mark - URL and WebRequest Related Methods
// helper function: get the url encoded string form of any object
+(NSString *)urlEncode:(NSString *)value {
	return [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}
@end