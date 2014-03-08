//
//  MovieCell.h
//  Homework4
//
//  Created by Gaurang Jadia on 2/12/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "AppHelper.h"
#import "UIImageView+WebCache.h"

@interface MovieCell : UITableViewCell
{
	UIImageView *ivPoster;
	UILabel *lTitle;
	UILabel *lRating;
	UILabel *lReleaseDate;
	UILabel *lRunTime;
	UIImageView *ivDetailArrow;
}

@property (nonatomic, strong) UIImageView *ivPoster;
@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UILabel *lRating;
@property (nonatomic, strong) UILabel *lReleaseDate;
@property (nonatomic, strong) UILabel *lRunTime;
@property (nonatomic, strong) UIImageView *ivDetailArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier movie:(Movie *)objMovie rowNumber:(NSInteger)rowNumber;
- (id)reload:(Movie *)objMovie rowNumber:(NSInteger)rowNumber;
@end