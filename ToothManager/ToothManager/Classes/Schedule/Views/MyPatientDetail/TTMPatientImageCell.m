//
//  TTMPatientImageCell.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMPatientImageCell.h"
#import "UIColor+TTMAddtion.h"
#import "TTMImageListView.h"
#import "TTMAppointPatientModel.h"
#import "Masonry.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

static const CGFloat TTMPatientImageCellHeight = 45;

@interface TTMPatientImageCell ()

@property (nonatomic, strong)TTMImageListView *listView;

@end

@implementation TTMPatientImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"patient_image_cell";
    TTMPatientImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.listView];

    
    [self setUpTap];
    //设置frame
    [self setUpFrame];
}
#pragma mark 设置可响应按钮点击事件
- (void)setUpTap{
    for (id obj in self.subviews) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"]) {
            UIScrollView *scroll  = (UIScrollView *)obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
}

- (void)setUpFrame{
    CGFloat margin = 10;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(margin);
        make.top.equalTo(self.contentView).with.offset((TTMPatientImageCellHeight - 20) / 2);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-margin);
        make.top.equalTo(self.contentView).with.offset((TTMPatientImageCellHeight - 20) / 2);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(margin);
        make.height.mas_equalTo(20);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(TTMPatientImageCellHeight);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setImageList:(NSArray *)imageList{
    _imageList = imageList;
    
    [self.listView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (imageList.count > 0) {
        
        CGFloat itemSpacing = 10; //item初始间距
        CGFloat imageWidth = 60;
        //计算一行显示几张图片
        NSInteger count = (ScreenWidth - itemSpacing) / (imageWidth + itemSpacing);
        CGFloat margin = (ScreenWidth - imageWidth * count) / (count + 1);
        //计算总共有几行
        NSInteger rows = 0;
        if (imageList.count > count) {
            rows = imageList.count % count == 0 ? imageList.count / count : imageList.count / count + 1;
        }else{
            rows = 1;
        }
        
        NSMutableArray *subViews = [NSMutableArray array];
        for (int i = 0; i < self.imageList.count; i++) {
            TTMAppointImageModel *imageModel = self.imageList[i];
            
            int index_x = i / count;
            int index_y = i % count;
            
            CGFloat imageX = margin + (margin + imageWidth) * index_y;
            CGFloat imageY = itemSpacing + (itemSpacing + imageWidth) * index_x;
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);
            imageView.tag = i + 100;
            imageView.layer.cornerRadius = 5;
            imageView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
//            [imageView addGestureRecognizer:tap];
            imageView.layer.masksToBounds = YES;
            
            [self.listView addSubview:imageView];
            [subViews addObject:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.reserverPath]];
        }
    }
}

#pragma mark 图片点击事件
- (void)imageTapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (TTMAppointImageModel *model in self.imageList) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:model.reserverPath];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = imageView.tag - 100;
    //显示
    [browser show];
}

#pragma mark cell高度
+ (CGFloat)cellHeightWithImageList:(NSArray *)imageList{
    if (imageList.count == 0 || !imageList) {
        return TTMPatientImageCellHeight;
    }
     CGFloat itemSpacing = 10; //item间距
    CGFloat imageWidth = 60;
    //计算一行显示几张图片
    NSInteger count = (ScreenWidth - itemSpacing) / (imageWidth + itemSpacing);
    //计算总共有几行
    NSInteger rows = 0;
    if (imageList.count > count) {
        rows = imageList.count % count == 0 ? imageList.count / count : imageList.count / count + 1;
    }else{
        rows = 1;
    }
    
    return TTMPatientImageCellHeight + rows * (imageWidth + itemSpacing) + itemSpacing;
}

#pragma mark - ********************* Lazy Method ***********************
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = [UIColor colorWithHex:0x333333];
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

- (TTMImageListView *)listView{
    if (!_listView) {
        _listView = [[TTMImageListView alloc] init];
        _listView.userInteractionEnabled = YES;
        _listView.backgroundColor = [UIColor whiteColor];
    }
    return _listView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.listView];
    //判断当前点击是否在
    for (UIImageView *view in self.listView.subviews) {
        if(CGRectContainsPoint(view.frame, point)){
            //找到当前点击的imageView
            //获取当前点击的视图
            UIImageView *imageView = view;
            //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
            NSMutableArray *mJPhotos = [NSMutableArray array];
            int i = 0;
            for (TTMAppointImageModel *model in self.imageList) {
                //将图片url转换成高清的图片url
                MJPhoto *mjPhoto = [[MJPhoto alloc] init];
                mjPhoto.url = [NSURL URLWithString:model.reserverPath];
                mjPhoto.srcImageView = imageView;
                mjPhoto.index = i;
                [mJPhotos addObject:mjPhoto];
                i++;
            }
            //创建图片显示控制器对象
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.photos = mJPhotos;
            browser.currentPhotoIndex = imageView.tag - 100;
            //显示
            [browser show];
            break;
        }
    }
}

@end
