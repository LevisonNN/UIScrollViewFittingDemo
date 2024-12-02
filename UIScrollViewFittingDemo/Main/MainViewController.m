//
//  MainViewController.m
//  UIScrollViewFittingDemo
//
//  Created by Levison on 2.12.24.
//

#import "MainViewController.h"
#import "DemoCell.h"
#import "DecelerateViewController.h"

@interface DemoObj : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) Class vcClass;

@end

@implementation DemoObj

@end

@interface MainViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) NSArray<DemoObj *> *demoList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    DemoObj *decelerateDemo = [[DemoObj alloc] init];
    decelerateDemo.title = @"Decelerate";
    decelerateDemo.vcClass = DecelerateViewController.class;
    [mArr addObject:decelerateDemo];
    
    self.demoList = [NSArray arrayWithArray:mArr];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demoList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88.f, 32.f);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = (DemoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"kDemoCell" forIndexPath:indexPath];
    DemoObj *obj = [self.demoList objectAtIndex:indexPath.item];
    cell.titleLabel.text = obj.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoObj *obj = [self.demoList objectAtIndex:indexPath.item];
    UIViewController *vc = [[obj.vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
