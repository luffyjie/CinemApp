//
//  MovieView.h
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-18.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RateViewController;
@class MovieTableView;
@class MovieTableViewController;


@interface MovieView : UIView<UITextFieldDelegate>

-(id)initWithMovieInfo:(CGRect)frame
                      :(NSData*)posterImage
                      :(NSString *)moviePlot
                      :(NSMutableArray *)directors
                      :(NSMutableArray *)writers
                      :(UIView *)castTableView
                      :(RateViewController *)rateViewController;

@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) UITextView *plotView;
@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) NSData *posterImage;
@property (nonatomic, strong) UILabel *castLabel;
@property (nonatomic, strong) UILabel *directorLabel;
@property (nonatomic, strong) UILabel *writerLabel;
@property (nonatomic, strong) UITableView *castTable;
@property (nonatomic, strong) NSMutableArray* directorsArray;
@property (nonatomic, strong) NSMutableArray* writersArray;
@property (nonatomic, strong) RateViewController* rvc;
@property BOOL plotEnlarged;

- (void)textViewDidChange:(UITextView *)textView;

@end
