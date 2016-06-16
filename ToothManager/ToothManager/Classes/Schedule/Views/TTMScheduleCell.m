//
//  TTMScheduleCell.m
//  ToothManager
//

#import "TTMScheduleCell.h"
#import "TTMScheduleHeadImageView.h"
#import "UIColor+TTMAddtion.h"
#import "Masonry.h"


#define kTextColor [UIColor blackColor]
#define kTextFont [UIFont systemFontOfSize:14]

#define kReserveTypeTextColor [UIColor colorWithHex:0x2abcc6]
#define kStatusEndColor [UIColor colorWithHex:0xff3825]
#define kStatusBeginColor [UIColor colorWithHex:0x30ac4a]
#define kDividerColor [UIColor colorWithHex:0xcccccc]

#define kTimeImageW 15.f
#define kMargin 10.f
#define kRowHeight 105.0f
#define kDividerHeight 1.f
#define kTimeButtonWidth 100
#define kTopViewHeight 35
#define kStatusLabelWidth 100
#define kHeadImageWidth 60
#define kContenWidth ((ScreenWidth - 5 * kMargin) / 3)
#define kContentHeight 20

@interface TTMScheduleCell ()

@property (nonatomic, strong)UIButton *timeButton;//时间
@property (nonatomic, strong)UILabel *statusLabel;//状态
@property (nonatomic, strong)UIView *dividerView;//分割线
@property (nonatomic, strong)UIView *topDividerView;//分割线
@property (nonatomic, strong)UIView *bottomDividerView;//分割线
@property (nonatomic, strong)TTMScheduleHeadImageView *headerImageView;//医生头像
@property (nonatomic, strong)UILabel *patientNameLabel;//患者姓名
@property (nonatomic, strong)UILabel *reserveTypeLabel;//预约事项
@property (nonatomic, strong)UILabel *seatNameLabel;//椅位
@property (nonatomic, strong)UIImageView *assistImageView;//是否有助手
@property (nonatomic, strong)UIImageView *materialImageView;//是否有耗材

@end

@implementation TTMScheduleCell

+ (instancetype)scheduleCellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"CellID";
    TTMScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    [self.contentView addSubview:self.timeButton];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.dividerView];
    [self.contentView addSubview:self.topDividerView];
    [self.contentView addSubview:self.bottomDividerView];
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.patientNameLabel];
    [self.contentView addSubview:self.reserveTypeLabel];
    [self.contentView addSubview:self.seatNameLabel];
    [self.contentView addSubview:self.assistImageView];
    [self.contentView addSubview:self.materialImageView];
    
    
    //设置约束
    [self setUpContrains];
}

#pragma mark - 设置约束
- (void)setUpContrains{
    [self.topDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(kDividerHeight);
    }];
    
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(kTimeButtonWidth);
        make.height.mas_equalTo(kTopViewHeight);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-kMargin);
        make.width.mas_equalTo(kStatusLabelWidth);
        make.height.mas_equalTo(kTopViewHeight);
    }];
    
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kTopViewHeight);
        make.left.equalTo(self.contentView).with.offset(kMargin);
        make.right.equalTo(self.contentView).with.offset(-kMargin);
        make.height.mas_equalTo(kDividerHeight);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kMargin);
        make.top.equalTo(self.dividerView.mas_bottom).with.offset(kMargin / 2);
        make.width.mas_equalTo(kHeadImageWidth);
        make.height.mas_equalTo(kHeadImageWidth);
    }];
    
    [self.patientNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).with.offset(kMargin / 2);
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
        make.height.mas_equalTo(kContentHeight);
        
        make.width.mas_equalTo(self.reserveTypeLabel.mas_width);
        make.right.equalTo(self.reserveTypeLabel.mas_left).with.offset(-kMargin / 2);
    }];
    
    [self.reserveTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.patientNameLabel.mas_centerY);
        make.height.mas_equalTo(kContentHeight);
        make.width.mas_equalTo(self.seatNameLabel.mas_width);
        make.right.equalTo(self.seatNameLabel.mas_left).with.offset(-kMargin / 2);
    }];
    
    [self.seatNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.patientNameLabel.mas_centerY);
        make.height.mas_equalTo(kContentHeight);
        make.right.equalTo(self.materialImageView.mas_left).with.offset(-kMargin / 2);
        make.width.mas_equalTo(self.patientNameLabel.mas_width);
    }];
    
    [self.assistImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
        make.right.equalTo(self.contentView).with.offset(-kMargin);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.materialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headerImageView.mas_centerY);
        make.right.equalTo(self.assistImageView.mas_left).with.offset(-kMargin);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.bottomDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

/**
 *  设置model
 *
 *  @param model model description
 */
- (void)setModel:(TTMScheduleCellModel *)model {
    _model = model;
    
    [self.timeButton setTitle:[model.appoint_time substringWithRange:NSMakeRange(10, 6)] forState:UIControlStateNormal];
    if (model.status >= TTMApointmentStatusEnded) {
        self.statusLabel.text = @"已结束";
        self.statusLabel.textColor = kStatusEndColor;
    }else if (model.status == TTMApointmentStatusStarting){
        self.statusLabel.text = @"计时中";
        self.statusLabel.textColor = kStatusBeginColor;
    }else{
        self.statusLabel.text = @"";
    }
    self.headerImageView.name = model.doctor_name;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.doctor_image] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.patientNameLabel.text = model.patient_name;
    self.reserveTypeLabel.text = model.appoint_type;
    self.seatNameLabel.text = model.seat_name;
    
    //判断是否存在耗材
    if (model.materialCount == 0) {
        self.materialImageView.hidden = YES;
    }else{
        self.materialImageView.hidden = NO;
    }
    
    if (model.assistCount == 0) {
        self.assistImageView.hidden = YES;
    }else{
        self.assistImageView.hidden = NO;
    }

}

#pragma mark - ********************* Lazy Method ***********************
- (UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setTitleColor:kTextColor forState:UIControlStateNormal];
        [_timeButton setImage:[UIImage imageNamed:@"schedule_tag_time"] forState:UIControlStateNormal];
        [_timeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _timeButton.titleLabel.font = kTextFont;
    }
    return _timeButton;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = kTextFont;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UIView *)dividerView{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = kDividerColor;
    }
    return _dividerView;
}

- (UIView *)topDividerView{
    if (!_topDividerView) {
        _topDividerView = [[UIView alloc] init];
        _topDividerView.backgroundColor = kDividerColor;
    }
    return _topDividerView;
}

- (UIView *)bottomDividerView{
    if (!_bottomDividerView) {
        _bottomDividerView = [[UIView alloc] init];
        _bottomDividerView.backgroundColor = kDividerColor;
    }
    return _bottomDividerView;
}

- (TTMScheduleHeadImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[TTMScheduleHeadImageView alloc] init];
        _headerImageView.layer.borderWidth = 1;
        _headerImageView.layer.borderColor = [kDividerColor CGColor];
        _headerImageView.layer.cornerRadius = 5;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)patientNameLabel{
    if (!_patientNameLabel) {
        _patientNameLabel = [[UILabel alloc] init];
        _patientNameLabel.textColor = kTextColor;
        _patientNameLabel.font = kTextFont;
        _patientNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _patientNameLabel;
}

- (UILabel *)reserveTypeLabel{
    if (!_reserveTypeLabel) {
        _reserveTypeLabel = [[UILabel alloc] init];
        _reserveTypeLabel.font = kTextFont;
        _reserveTypeLabel.textColor = kReserveTypeTextColor;
        _reserveTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _reserveTypeLabel;
}

- (UILabel *)seatNameLabel{
    if (!_seatNameLabel) {
        _seatNameLabel = [[UILabel alloc] init];
        _seatNameLabel.textColor = kTextColor;
        _seatNameLabel.font = kTextFont;
        _seatNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _seatNameLabel;
}

- (UIImageView *)assistImageView{
    if (!_assistImageView) {
        _assistImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_tag_assist"]];
        _assistImageView.hidden = YES;
    }
    return _assistImageView;
}

- (UIImageView *)materialImageView{
    if (!_materialImageView) {
        _materialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_tag_material"]];
        _materialImageView.hidden = YES;
    }
    return _materialImageView;
}


@end
