//
//  PENSuggestedUserCell.m
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "PENSuggestedUserCell.h"
#import <AppDotNet/UIImageView+AFNetworking.h>


@implementation PENSuggestedUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)update
{
    self.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.user.name, self.count];
    [self.imageView setImageWithURL:self.user.avatarImage.url placeholderImage:[UIImage imageNamed:@"WhitePixel.png"]];
    
    if (self.youFollow) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.imageView.alpha = 0.3;
    } else {
        self.textLabel.textColor = [UIColor darkTextColor];
        self.imageView.alpha = 1;
    }
}

@end
