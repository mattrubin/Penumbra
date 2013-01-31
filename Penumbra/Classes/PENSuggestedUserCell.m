//
//  PENSuggestedUserCell.m
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "PENSuggestedUserCell.h"


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
    if (self.youFollow) {
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.textColor = [UIColor darkTextColor];
    }
}


#pragma mark - Accessors

- (void)setUser:(ADNUser *)user
{
    if (_user != user) {
        _user = user;
        [self update];
    }
}

- (void)setCount:(NSNumber *)count
{
    if (_count != count) {
        _count = [count copy];
        [self update];
    }
}

- (void)setYouFollow:(BOOL)youFollow
{
    if (_youFollow != youFollow) {
        _youFollow = youFollow;
        [self update];
    }
}

@end
