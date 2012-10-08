//
//  AFActivityIndicatorView.m
//  Animation Test
//
//  Created by Ash Furrow on 2012-09-21.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>       //Note: You'll have to link with QuarzCore. Deal with it.
#import "AFActivityIndicatorView.h"

#define kSmallLineStartRadius   6
#define kSmallLineEndRadius     9
#define kSmallLineStrokeWidth   2

#define kLargeLineStartRadius   10
#define kLargeLineEndRadius     16
#define kLargeLineStrokeWidth   3

//does a linear interpolation between a and b, given float amount between 0 and 1
static CGFloat lerp (CGFloat a, CGFloat b, CGFloat amount)
{
    return a + amount * (b - a);
}

@implementation AFActivityIndicatorView
{
    CADisplayLink *displayLink;
    BOOL isAnimating;
    
    NSInteger currentHighlightedIndex;
    
    CGFloat activeAlphaValue;
    CGFloat inactiveAlphaValue;
    CGFloat whiteValue;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    currentHighlightedIndex = 0;
    
    [self.layer setOpaque:NO];
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const NSInteger numberOfSegments = 12;
    
    //Draw each line segment
    for (NSInteger index = 0; index < numberOfSegments; index++)
    {
        //centre of the circle
        CGPoint origin = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

        NSInteger distanceFromHighlightedIndex = index - currentHighlightedIndex;
        if (distanceFromHighlightedIndex < 0)
        {
            distanceFromHighlightedIndex += numberOfSegments;
        }
        
        CGFloat endRadius = kSmallLineEndRadius;
        CGFloat startRadius = kSmallLineStartRadius;
        CGFloat strokeWidth = kSmallLineStrokeWidth;
        
        if (_activityIndicatorViewStyle == AFActivityIndicatorViewStyleLargeWhite)
        {
            endRadius = kLargeLineEndRadius;
            startRadius = kLargeLineStartRadius;
            strokeWidth = kLargeLineStrokeWidth;
        }
        
        CGFloat colourWhiteValue;
        if (distanceFromHighlightedIndex > numberOfSegments / 2)
        {
            colourWhiteValue = inactiveAlphaValue;
        }
        else
        {   
            CGFloat amount = (CGFloat)distanceFromHighlightedIndex / ((CGFloat)numberOfSegments / 2.0f);
            
            colourWhiteValue = lerp(inactiveAlphaValue, activeAlphaValue, amount);
        }
        
        //draw the actual segment
        CGContextSaveGState(context);
        {
            [[UIColor colorWithWhite:whiteValue alpha:colourWhiteValue] set];
            CGContextSetLineWidth(context, strokeWidth);
            CGContextSetLineCap(context, kCGLineJoinRound);
            CGContextBeginPath(context);
            
            //Standar equation for calculating points on a cricle
            CGFloat x, y;
            CGFloat radians = M_PI * 2 * ((CGFloat)index / (CGFloat)12);
            
            x = origin.x + startRadius * cosf(radians);
            y = origin.y + startRadius * sinf(radians);
            CGContextMoveToPoint(context, x, y);
            
            x = origin.x + endRadius * cosf(radians);
            y = origin.y + endRadius * sinf(radians);
            CGContextAddLineToPoint(context, x, y);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
    
    //increment our currently highlighted segment
    currentHighlightedIndex+=1;
    
    if (currentHighlightedIndex >= numberOfSegments)
    {
        currentHighlightedIndex -= numberOfSegments;
    }
}

-(void)startAnimating
{
    [self setHidden:NO];
    
    if (!displayLink)
    {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        displayLink.frameInterval = 5.0f;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        isAnimating = YES;
    }
}

-(void)stopAnimating
{
    if (self.hidesWhenStopped)
    {
        [self setHidden:YES];
    }
    
    [displayLink invalidate];
    displayLink = nil;
    isAnimating = NO;
}

-(BOOL)isAnimating
{
    return isAnimating;
}

-(void)setActivityIndicatorViewStyle:(AFActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    //These numbers were derived empiracally and could be a little off.
    switch (_activityIndicatorViewStyle)
    {
        case AFActivityIndicatorViewStyleLargeWhite:
        case AFActivityIndicatorViewStyleWhite:
            inactiveAlphaValue = 83.0/255.0;
            activeAlphaValue = 220.0/255.0;
            whiteValue = 1.0f;
            break;
        case AFActivityIndicatorViewStyleGray:
            inactiveAlphaValue = 42.0/255.0;
            activeAlphaValue = 112.0/255.0;
            whiteValue = 0.0f;
            break;
    }
    
    [self setNeedsDisplay];
}

-(void)dealloc
{
    [self stopAnimating];
}

@end
