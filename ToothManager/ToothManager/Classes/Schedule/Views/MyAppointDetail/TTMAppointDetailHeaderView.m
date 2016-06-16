//
//  TTMAppointDetailHeaderView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointDetailHeaderView.h"
#import "TTMScheduleCellModel.h"
#import "TTMDoctorTool.h"
#import "TTMPatientTool.h"

@interface TTMAppointDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *doctorSuperView;
@property (weak, nonatomic) IBOutlet UIView *patientSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation TTMAppointDetailHeaderView

- (void)awakeFromNib{
    self.doctorSuperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
    self.patientSuperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
    self.headerImageView.layer.cornerRadius = 35;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setModel:(TTMScheduleCellModel *)model{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.doctor_image] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = model.doctor_name;
    self.desLabel.text = [NSString stringWithFormat:@"%@  %@",model.doctor_hospital,model.doctor_dept];

}
- (IBAction)contactDoctorAction:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.superview text:@"获取医生电话..."];
    //查询医生的电话
    [TTMDoctorTool requestDoctorInfoWithDoctorId:self.model.doctor_id success:^(TTMDoctorModel *dcotorInfo) {
        [hud hide:YES];
        if(dcotorInfo.doctor_phone.length > 0 && dcotorInfo.doctor_phone != nil){
            NSString *message = [NSString stringWithFormat:@"拨打电话%@",dcotorInfo.doctor_phone];
            CYAlertView *alertView = [[CYAlertView alloc] initWithTitle:nil message:message clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    //拨打电话
                    NSString *number = dcotorInfo.doctor_phone;
                    NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [MBProgressHUD showToastWithText:@"医生未留电话!"];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showToastWithText:@"医生电话获取失败！"];
    }];
    
    
}
- (IBAction)contactPatientLabel:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.superview text:@"获取患者电话..."];
    [TTMPatientTool requestPatientInfoWithpatientId:self.model.patient_id success:^(TTMPatientModel *result) {
        [hud hide:YES];
        NSString *message = [NSString stringWithFormat:@"拨打电话%@",result.patient_phone];
        if(result.patient_phone.length > 0 && result.patient_phone != nil){
            CYAlertView *alertView = [[CYAlertView alloc] initWithTitle:nil message:message clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    //拨打电话
                    NSString *number = result.patient_phone;
                    NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [MBProgressHUD showToastWithText:@"患者未留电话!"];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showToastWithText:@"患者电话获取失败！"];
    }];
}


@end
