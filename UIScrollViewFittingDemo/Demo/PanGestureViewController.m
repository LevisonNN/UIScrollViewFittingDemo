//
//  PanGestureViewController.m
//  UIScrollViewFittingDemo
//
//  Created by Levison on 3.12.24.
//

#import "PanGestureViewController.h"
#import "DemoCell.h"


@interface PanGestureFunctionPoint : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

@implementation PanGestureFunctionPoint

+ (instancetype)pointWithX:(CGFloat)x y:(CGFloat)y
{
    PanGestureFunctionPoint *p = [[self alloc] init];
    p.x = x;
    p.y = y;
    return p;
}

@end

@interface PanGestureFit : NSObject

@property (nonatomic, assign) CGFloat k;
@property (nonatomic, assign) CGFloat b;

@property (nonatomic, assign) CGFloat kStep;
@property (nonatomic, assign) CGFloat bStep;

@property (nonatomic, copy) NSArray<PanGestureFunctionPoint *> *pArr;

@end

@implementation PanGestureFit

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.k = 0;
        self.b = 0;
        self.kStep = 0.0001f;
        self.bStep = 0.001f;
    }
    return self;
}

- (void)fit
{
    self.k = 0;
    self.b = 0;
    CGFloat variance = [self varianceWith:self.k b:self.b];
    while (1) {
        NSInteger type = 0;
        CGFloat minVariance = variance;
        CGFloat variance1 = [self varianceWith:self.k + self.kStep b:self.b];
        CGFloat variance2 = [self varianceWith:self.k - self.kStep b:self.b];
        CGFloat variance3 = [self varianceWith:self.k b:self.b + self.bStep];
        CGFloat variance4 = [self varianceWith:self.k b:self.b - self.bStep];
        if (variance1 < minVariance) {
            minVariance = variance1;
            type = 1;
        }
        if (variance2 < minVariance) {
            minVariance = variance2;
            type = 2;
        }
        if (variance3 < minVariance) {
            minVariance = variance3;
            type = 3;
        }
        if (variance4 < minVariance) {
            minVariance = variance4;
            type = 4;
        }
        
        variance = minVariance;
        
        if (type == 1) {
            self.k = self.k + self.kStep;
        } else if (type == 2) {
            self.k = self.k - self.kStep;
        } else if (type == 3) {
            self.b = self.b + self.bStep;
        } else if (type == 4) {
            self.b = self.b - self.bStep;
        } else {
            //已最接近
            NSLog(@"k: %@, b: %@ variance: %@", @(self.k), @(self.b), @(variance));
            break;
        }
    }
}

- (CGFloat)varianceWith:(CGFloat)k b:(CGFloat)b
{
    CGFloat sum = 0;
    for(PanGestureFunctionPoint *p in self.pArr) {
        CGFloat y = k * p.x + b;
        CGFloat y2 = p.y;
        sum += (y - y2)*(y - y2);
    }
    return sum;
}

@end

@interface PanGestureFunctionView : UIView

@property (nonatomic, strong) NSMutableArray<PanGestureFunctionPoint *> *points;
@property (nonatomic, strong) NSMutableArray<UIView *> *pointViews;

@end

@implementation PanGestureFunctionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)addPoint:(PanGestureFunctionPoint *)p
{
    [self.points addObject:p];
    UIView *pointView = [[UIView alloc] init];
    pointView.frame = CGRectMake(p.x, self.bounds.size.height - p.y, 1.f, 1.f);
    pointView.backgroundColor = [UIColor redColor];
    [self addSubview:pointView];
    [self.pointViews addObject:pointView];
}

- (void)clear
{
    for (UIView *v in self.pointViews) {
        [v removeFromSuperview];
    }
    [self.pointViews removeAllObjects];
    [self.points removeAllObjects];
}

- (NSMutableArray<PanGestureFunctionPoint *> *)points
{
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    return _points;
}

- (NSMutableArray<UIView *> *)pointViews
{
    if (!_pointViews) {
        _pointViews = [[NSMutableArray alloc] init];
    }
    return _pointViews;
}

@end


@interface PanGestureViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL tracking;

@property (nonatomic, assign) CGFloat gestureStartY;
@property (nonatomic, assign) CGFloat scrollViewStartOffsetY;

@property (nonatomic, strong) PanGestureFunctionView *functionView;

@property (nonatomic, strong) PanGestureFit *fit;

@end

@implementation PanGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.functionView];
    [self.view addSubview:self.collectionView];
    [self.collectionView addGestureRecognizer:self.panGesture];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.functionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    //修改高度，k发生变化，b保持不变
    CGFloat collectionViewHeight = 1000;
    self.collectionView.frame = CGRectMake(0, 300, self.view.bounds.size.width, collectionViewHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
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

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealWith:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (void)dealWith:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.tracking = YES;
        self.gestureStartY = [panGesture locationInView:self.view].y;
        self.scrollViewStartOffsetY = -self.collectionView.contentOffset.y;
    } else if(panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat gestureYOffset = [panGesture locationInView:self.view].y;
        CGFloat scrollViewOffset = -self.collectionView.contentOffset.y;
        CGFloat deltaGestureY = gestureYOffset - self.gestureStartY;
        CGFloat deltaViewOffset = scrollViewOffset - self.scrollViewStartOffsetY;
        if (deltaGestureY <= 0) {
            return;
        }
        CGFloat percent = deltaViewOffset/deltaGestureY;
        [self.functionView addPoint:[PanGestureFunctionPoint pointWithX:scrollViewOffset y:percent * 100]];
    } else {
        self.tracking = NO;
        self.gestureStartY = 0.f;
        self.scrollViewStartOffsetY = 0.f;
        self.fit.pArr = [NSArray arrayWithArray:self.functionView.points];
        [self.fit fit];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:DemoCell.class forCellWithReuseIdentifier:@"kDemoCell"];
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
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

- (PanGestureFunctionView *)functionView
{
    if (!_functionView) {
        _functionView = [[PanGestureFunctionView alloc] init];
    }
    return _functionView;
}

- (PanGestureFit *)fit
{
    if (!_fit) {
        _fit = [[PanGestureFit alloc] init];
    }
    return _fit;
}

@end
