//
//  PENAuthenticationViewController.h
//  Penumbra
//
//  Created by Me on 1/30/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PENAuthenticationDelegate <NSObject>

- (void)authenticationComplete;

@end


@interface PENAuthenticationViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) id <PENAuthenticationDelegate> delegate;

@end
