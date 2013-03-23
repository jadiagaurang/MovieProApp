//
//  MovieCell.m
//  Homework4
//
//  Created by Gaurang Jadia on 2/12/12.
//  Copyright (c) 2012 California State University, Los Angeles. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

@synthesize ivPoster, ivDetailArrow;
@synthesize lTitle, lRating, lReleaseDate, lRunTime;

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame= CGRectMake(boundsX + 5, 5, 75, 90);
	ivPoster.frame = frame;
	
	frame= CGRectMake(boundsX + 85, 5, 210, 30);
	lTitle.frame = frame;
	
	frame= CGRectMake(boundsX + 85, 35, 210, 20);
	lRating.frame = frame;
	
	frame= CGRectMake(boundsX + 85, 55, 210, 20);
	lReleaseDate.frame = frame;
	
	frame= CGRectMake(boundsX + 85, 75, 210, 20);
	lRunTime.frame = frame;
	
	frame= CGRectMake(boundsX + 278, 34, 32, 32);
	ivDetailArrow.frame = frame;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier movie:(Movie *)objMovie rowNumber:(NSInteger)rowNumber
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
	    //Set Selection Style to Gray
	    self.selectionStyle = UITableViewCellSelectionStyleGray;
	    
	    //Set up subviews
	    ivPoster = [[UIImageView alloc] init];
	    [ivPoster setImageWithURL:[NSURL URLWithString:[objMovie.posters objectAtIndex:0]]
				    placeholderImage:[UIImage imageNamed:@"MovieCellPlaceholder.png"] success:^(UIImage *image) {
					    //Do something here...
				    }
				    failure:^(NSError *error) {
					    //Do something here...
				    }];
	    
	    //ivPoster = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[objMovie.posters objectAtIndex:0]]]]];
	    
	    lTitle = [[UILabel alloc] init];
	    lTitle.backgroundColor = [UIColor clearColor];
	    lTitle.font = [UIFont fontWithName:AppFontBold size:18];
	    lTitle.text = [objMovie title];
	    
	    lRating = [[UILabel alloc] init];
	    lRating.backgroundColor = [UIColor clearColor];
	    lRating.font = [UIFont fontWithName:AppFont size:14];
	    lRating.text = [NSString stringWithFormat:@"%@", [objMovie rating]];

	    lReleaseDate = [[UILabel alloc] init];
	    lReleaseDate.backgroundColor = [UIColor clearColor];
	    lReleaseDate.font = [UIFont fontWithName:AppFont size:14];//boldSystemFontOfSize:12];
	    lReleaseDate.text = [NSString stringWithFormat:@"%@", [AppHelper getStringByDate:[objMovie release_dates] formatter:@"MMMM d, y"]];

	    lRunTime = [[UILabel alloc] init];
	    lRunTime.backgroundColor = [UIColor clearColor];
	    lRunTime.font = [UIFont fontWithName:AppFont size:14];
	    lRunTime.text = [NSString stringWithFormat:@"%d Minutes", [objMovie runtime]];
	    
	    ivDetailArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowright.png"]];
	    
	    UIView *lab = [[UIView alloc] initWithFrame:self.frame];
	    if((rowNumber % 2) == 0) {
		    [lab setBackgroundColor:[UIColor whiteColor]];
	    }
	    else {
		    [lab setBackgroundColor:[AppHelper getColorByHex:0x89898922]];
	    }
	    self.backgroundView = lab;
	    
	    [self.contentView addSubview:ivPoster];
	    [self.contentView addSubview:lTitle];
	    [self.contentView addSubview:lRating];
	    [self.contentView addSubview:lReleaseDate];
	    [self.contentView addSubview:lRunTime];
	    [self.contentView addSubview:ivDetailArrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)setHighlighted: (BOOL)highlighted animated: (BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	if(highlighted) {
		//Customize here...
	}
}

#pragma mark - Utility Methods
- (id)getMoneyByInt :(int) intArg {
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSString *formattedString =  [currencyFormatter stringFromNumber:[NSNumber numberWithInt:intArg]];
	return formattedString;
}
@end
