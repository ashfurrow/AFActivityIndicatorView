//
//  AFActivityIndicatorView.h
//  Animation Test
//
//  Created by Ash Furrow on 2012-10-07.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    AFActivityIndicatorViewStyleLargeWhite  = UIActivityIndicatorViewStyleWhiteLarge,
    AFActivityIndicatorViewStyleWhite       = UIActivityIndicatorViewStyleWhite,
    AFActivityIndicatorViewStyleGray        = UIActivityIndicatorViewStyleGray,
}AFActivityIndicatorViewStyle;

@interface AFActivityIndicatorView : UIView

@property (nonatomic, assign) AFActivityIndicatorViewStyle activityIndicatorViewStyle; // default is AFActivityIndicatorViewStyleWhite

@property(nonatomic) BOOL hidesWhenStopped; // default is YES. calls -setHidden when animating gets set to NO

-(void)stopAnimating;
-(void)startAnimating;
-(BOOL)isAnimating;

@end
