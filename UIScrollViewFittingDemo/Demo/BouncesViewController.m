//
//  BouncesViewController.m
//  UIScrollViewFittingDemo
//
//  Created by Levison on 2.12.24.
//

#import "BouncesViewController.h"
#import "DemoCell.h"

@interface BouncesViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL openRecord;
@property (nonatomic, assign) CGFloat startVelocity;
@property (nonatomic, assign) CGFloat maxOffset;

@end

@implementation BouncesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88.f, 88.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kDemoCell" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.openRecord) {
        if (scrollView.contentOffset.y < 0) {
            if (-scrollView.contentOffset.y >= self.maxOffset) {
                self.maxOffset = -scrollView.contentOffset.y;
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y < 0 &&
        fabs(targetContentOffset->y) < 0.01 &&
        scrollView.contentOffset.y > 0) {
        self.openRecord = YES;
        self.startVelocity = fabs(velocity.y * 1000) - scrollView.contentOffset.y * 2;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.openRecord) {
        self.openRecord = NO;
        NSLog(@"Bounces: startVelocity: %@ maxOffset:%@", @(self.startVelocity), @(self.maxOffset));
    }
    self.maxOffset = 0;
    self.startVelocity = 0;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:DemoCell.class forCellWithReuseIdentifier:@"kDemoCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}


@end
