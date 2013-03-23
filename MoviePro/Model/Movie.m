//
//  Movie.m
//  Homework3
//
//  Created by Gaurang Jadia on 1/29/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "Movie.h"
#import "AppHelper.h"

@implementation Movie

//START :: Implimentaion of Class Properties
@synthesize movieid, imdbid, title, year, rating, runtime, consensus, release_dates, synopsis, posters, cast, clips, photos, totalCollection;

//START :: Implimentaion of Class Properties
- (id)init {
	self = [super init];
	if (self) {
		movieid = @"";
		imdbid = @"";
		title = @"Untitle";
		year = 1900;
		rating = @"";
		runtime = 0;
		consensus = @"";
		release_dates = [NSDate alloc];
		synopsis = @"";
		posters = [[NSMutableArray alloc] init];
		cast = [[NSMutableArray alloc] init];
		clips = [[NSMutableArray alloc] init];
		photos = [[NSMutableArray alloc] init]; 
		totalCollection = 0;
	}
	return self;
}


-(id)initWithObject:(NSMutableDictionary *)movie {
	self = [self init];
	if (self) {
		movieid = [movie objectForKey:@"id"];
		imdbid = [@"tt" stringByAppendingFormat:@"%@&", [[movie objectForKey:@"alternate_ids"] objectForKey:@"imdb"]];
		title = [movie objectForKey:@"title"];
		year = [[movie objectForKey:@"year"] intValue];
		rating = [movie objectForKey:@"mpaa_rating"];
		runtime = [[movie objectForKey:@"runtime"] intValue];
		consensus = [movie objectForKey:@"critics_consensus"];
		release_dates = [AppHelper getDateByString:[[movie objectForKey:@"release_dates"] objectForKey:@"theater"] formatter:@"yyyy-MM-dd"];
		synopsis = [movie objectForKey:@"synopsis"];
		
		[posters addObject:[[movie objectForKey:@"posters"] objectForKey:@"thumbnail"]];
		[posters addObject:[[movie objectForKey:@"posters"] objectForKey:@"profile"]];
		[posters addObject:[[movie objectForKey:@"posters"] objectForKey:@"detailed"]];
		[posters addObject:[[movie objectForKey:@"posters"] objectForKey:@"original"]];
		
		NSMutableArray *arrayCast = [movie objectForKey:@"abridged_cast"];
		
		for(NSMutableDictionary *ca in arrayCast) {
			NSMutableDictionary *c = [[NSMutableDictionary alloc] init];
			if([ca objectForKey:@"name"] != nil) {
				[c setObject:[ca objectForKey:@"name"] forKey:@"name"];
			}
			
			if([ca objectForKey:@"characters"] != nil) {
				[c setObject:[ca objectForKey:@"characters"] forKey:@"characters"];
			}
			else {
				NSMutableArray *chara = [[NSMutableArray alloc] initWithObjects:@"Unavailable", nil];
				[c setObject:chara forKey:@"characters"];
			}
			[cast addObject:c];
		}
	}
	return self;
}

-(void)setupPhotos:(NSMutableArray *)argPhotos {
	for (id key in argPhotos) {
		id file_path = [key objectForKey: @"file_path"];
		NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
		[d setObject:[@"" stringByAppendingFormat:@"http://cf2.imgobject.com/t/p/w92%@", file_path] forKey:@"thumbnail"];
		[d setObject:[@"" stringByAppendingFormat:@"http://cf2.imgobject.com/t/p/original%@", file_path] forKey:@"original"];
		[photos addObject:d];
	}
}

-(void)setupClips:(NSMutableArray *)argClips {
	if([clips count] > 0) {
		[clips removeAllObjects];
	}
	
	self.clips = argClips;
}
@end