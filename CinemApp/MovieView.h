//
//  TestView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <JLTMDbClient.h>

@interface MovieView : UIView

-(id)initWithMovieInfo:(NSString *)moviePlot :(CGRect)frame;

@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) UITextField *plotField;

@end
