//
//  PENAppDelegate.h
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PENAuthenticationViewController.h"
#import "PENSuggestedUsersViewController.h"


@interface PENAppDelegate : UIResponder <UIApplicationDelegate, PENAuthenticationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PENAuthenticationViewController *authController;
@property (strong, nonatomic) PENSuggestedUsersViewController *usersController;

@end
