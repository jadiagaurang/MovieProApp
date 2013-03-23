//
//  Movie.h
//  Homework3
//
//  Created by Gaurang Jadia on 1/29/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject {

	//Movie Class - ivars
	NSString *movieid;
	NSString *imdbid;
	NSString *title;
	int year;
	NSString *rating;
	int runtime;
	NSString *consensus;
	NSDate *release_dates;
	NSString *synopsis;
	NSMutableArray *posters;
	NSMutableArray *cast;
	NSMutableArray *clips;
	NSMutableArray *photos;
	int totalCollection;
}

@property(nonatomic, strong) NSString *movieid;
@property(nonatomic, strong) NSString *imdbid;
@property(nonatomic, strong) NSString *title;
@property(assign) int year;
@property(nonatomic, strong) NSString *rating;
@property(assign) int runtime;
@property(nonatomic, strong) NSString *consensus;
@property(nonatomic, strong) NSDate *release_dates;
@property(nonatomic, strong) NSString *synopsis;
@property(nonatomic, strong) NSMutableArray *posters;
@property(nonatomic, strong) NSMutableArray *cast;
@property(nonatomic, strong) NSMutableArray *clips;
@property(nonatomic, strong) NSMutableArray *photos;
@property(assign) int totalCollection;

-(id)initWithObject:(NSMutableDictionary *)movie;
-(void)setupPhotos:(NSMutableArray *)argPhotos;
-(void)setupClips:(NSMutableArray *)argClips;
@end