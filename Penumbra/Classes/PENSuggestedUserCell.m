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
@property (nonatomic, strong) NSMutableArray *miniAvatars;

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
        
        self.miniAvatars = [NSMutableArray arrayWithCapacity:18];
        for (NSUInteger i=0; i<18; i++) {
            UIImageView *miniAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(65, 30, 25, 25)];
            miniAvatar.layer.cornerRadius = 5.0;
            miniAvatar.clipsToBounds = YES;
            [self.contentView addSubview:miniAvatar];
            [self.miniAvatars addObject:miniAvatar];
        }

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
    
    NSUInteger i = 0;
    for (UIImageView *miniAvatar in self.miniAvatars) {
        if (i < self.followerIds.count) {
            NSString *followerId = [self.followerIds objectAtIndex:i];
            NSString *urlString = [NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@/avatar", followerId];
            [miniAvatar setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"WhiteAvatar.png"]];
        } else {
            [miniAvatar setImage:[UIImage imageNamed:@"WhiteAvatar.png"]];
        }
        i++;
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
    
    CGFloat miniAvatarY = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + margin;
    CGFloat miniAvatarX = self.avatar.frame.origin.x + self.avatar.frame.size.width + margin*2;
    CGFloat miniAvatarSize = self.contentView.bounds.size.height - miniAvatarY - margin*2;
    for (UIView *miniAvatarView in self.miniAvatars) {
        miniAvatarView.frame = CGRectMake(miniAvatarX, miniAvatarY, miniAvatarSize, miniAvatarSize);
        miniAvatarX += miniAvatarSize + margin;
    }

}

@end
