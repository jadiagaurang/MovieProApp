//
//  AppHelper.h
//  Homework5
//
//  Created by Gaurang Jadia on 2/14/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface AppHelper : NSObject {
	
}

+(BOOL)checkNetworkStatus;
+(UIActivityIndicatorView *)getActivityViewer:(CGRect) frame;
+(void)stopActivityViewer:(UIView *)viewOwner;

+(BOOL)isIPhone;

+(NSDate *)getDateByString:(NSString *)date formatter:(NSString *)formatter;
+(NSString *)getStringByDate:(NSDate *)date formatter:(NSString *)formatter;
+(UIColor *) getColorByHex:(int) c;
+(BOOL) isFontExist:(NSString *) argFontName;

+(BOOL)isFileExist:(NSString *)strFileName;
+(NSString *)getDocsDirectory;
+(NSString *)getFilePathFromDocs:(NSString *)filename;
+(BOOL)setPlist:(NSString *)strPlistName;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue;
+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key;

+(NSString *)urlEncode:(NSString *)value;
@end