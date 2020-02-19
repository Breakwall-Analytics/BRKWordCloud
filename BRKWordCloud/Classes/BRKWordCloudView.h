//
//  BRKWordCloudView.swift
//  BRKWordCloud_Example
//
//  Created by Christopher Armenio on 2/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
@import UIKit;


@interface BRKWordCloudView : UIView

#pragma mark - Public properties
@property (nonatomic, strong, nullable) NSDictionary<NSString*, NSNumber*>* words;
@property (nonatomic, strong, nullable) NSString* fontName;
@property (nonatomic, strong, nullable) NSArray<UIColor*>* colors;

@end
