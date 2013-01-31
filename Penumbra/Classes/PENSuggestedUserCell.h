//
//  PENSuggestedUserCell.h
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PENSuggestedUserCell : UITableViewCell

- (void)update;

@property (nonatomic, strong) ADNUser *user;
@property (nonatomic, copy)   NSNumber *count;
@property (nonatomic, assign) BOOL youFollow;

@end
