//
//  BRKWordCloudView.swift
//  BRKWordCloud_Example
//
//  Created by Christopher Armenio on 2/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
#import "BRKWordCloudView.h"


#import "CloudLayoutOperation.h"


@interface BRKWordCloudView () <CloudLayoutOperationDelegate>

@end


@implementation BRKWordCloudView

#pragma mark - Public Getters / Setters
-(void) setWords:(NSDictionary<NSString *,NSNumber *> *)words
{
    _words = words;
    [self renderUI];
}


-(void) setFontName:(NSString *)fontName
{
    _fontName = fontName;
    [self renderUI];
}


-(void) setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    [self renderUI];
}


#pragma mark - Private Methods
-(void) renderUI
{
    // clear our current words
    [self removeCloudWords];
    
    // convert to the proper format
    NSMutableArray* xformWords = [[NSMutableArray alloc] init];
    for( NSString* currWord in self.words.allKeys )
    {
        [xformWords addObject:@{
            @"title": currWord,
            @"total": [self.words objectForKey:currWord] }
         ];
    }
    
    // do the layout operation
    CloudLayoutOperation* clo = [[CloudLayoutOperation alloc] initWithCloudWords:xformWords
                                                                           title:nil
                                                                        fontName:self.fontName
                                                            forContainerWithSize:self.bounds.size
                                                                           scale:UIScreen.mainScreen.scale delegate:self];
    [clo start];
}


-(void) removeCloudWords
{
    NSMutableArray *removableObjects = [[NSMutableArray alloc] init];

    // Remove cloud words (UILabels)

    for( id subview in self.subviews )
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            [removableObjects addObject:subview];
        }
    }

    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];

#ifdef DEBUG
    // Remove bounding boxes

    [removableObjects removeAllObjects];

    for( id sublayer in self.layer.sublayers )
    {
        if ([sublayer isKindOfClass:[CALayer class]] && ((CALayer *)sublayer).borderWidth && ![sublayer delegate])
        {
            [removableObjects addObject:sublayer];
        }
    }

    [removableObjects makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
#endif
}


#pragma mark - CloudLayoutOperationDelegate
-(void) insertTitle:(NSString *)cloudTitle
{
    // we don't support titles
}


-(void) insertWord:(NSString *)word
         pointSize:(CGFloat)pointSize
             color:(NSUInteger)color
            center:(CGPoint)center
          vertical:(BOOL)isVertical
{
    UILabel* wordLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    wordLabel.text = word;
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.textColor = (self.colors != nil) ? self.colors[color < self.colors.count ? color : 0] : UIColor.blackColor;
    wordLabel.font = (self.fontName != nil) ? [UIFont fontWithName:self.fontName size:pointSize] : [UIFont systemFontOfSize:pointSize];
    [wordLabel sizeToFit];

    // Round up size to even multiples to "align" frame without ofsetting center
    CGRect wordLabelRect = wordLabel.frame;
    wordLabelRect.size.width = ((CGFloat)(wordLabelRect.size.width + 3) / 2) * 2;
    wordLabelRect.size.height = ((CGFloat)(wordLabelRect.size.height + 3) / 2) * 2;
    wordLabel.frame = wordLabelRect;

    wordLabel.center = center;

    if( isVertical )
    {
        wordLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    }

    [self addSubview:wordLabel];
}

@end
