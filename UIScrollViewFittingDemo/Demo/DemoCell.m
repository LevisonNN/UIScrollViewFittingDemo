//
//  DemoCell.m
//  UIScrollViewFittingDemo
//
//  Created by Levison on 2.12.24.
//

#import "DemoCell.h"

@interface DemoCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DemoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor colorWithRed:(random()%255)/255.f green:(random()%255)/255.f blue:(random()%255)/255.f alpha:1.f];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)addSubviews
{
    [self.contentView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
