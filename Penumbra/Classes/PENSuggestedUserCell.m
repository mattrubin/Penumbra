//
//  PENSuggestedUserCell.m
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "PENSuggestedUserCell.h"
#import <AppDotNet/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>


@interface PENSuggestedUserCell ()

@property (nonatomic, strong) UIImageView *avatar;

@end


@implementation PENSuggestedUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        self.avatar.layer.cornerRadius = 5.0;
        self.avatar.clipsToBounds = YES;
        [self.contentView addSubview:self.avatar];
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
    self.textLabel.text = self.user.name;
    self.detailTextLabel.text = [@"@" stringByAppendingString:self.user.username];
    
    [self.avatar setImageWithURL:self.user.avatarImage.url placeholderImage:[UIImage imageNamed:@"WhiteAvatar.png"]];
    
    if (self.youFollow) {
        self.contentView.alpha = 0.3;
        self.imageView.alpha = 0.3;
    } else {
        self.contentView.alpha = 1;
        self.imageView.alpha = 1;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 3.0;
    CGFloat avatarSize = self.contentView.bounds.size.height - (2.0 * margin);
    self.avatar.frame = CGRectMake(margin, margin, avatarSize, avatarSize);
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x += avatarSize;
    textLabelFrame.origin.y = margin;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = textLabelFrame.origin.x + textLabelFrame.size.width + margin;
    detailTextLabelFrame.origin.y = margin;
    detailTextLabelFrame.size.height = textLabelFrame.size.height;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
