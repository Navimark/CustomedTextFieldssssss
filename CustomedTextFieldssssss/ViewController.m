//
//  ViewController.m
//  CustomedTextFieldssssss
//
//  Created by IOS－001 on 15/3/10.
//  Copyright (c) 2015年 xxxx Information Technologies Co., LTD. All rights reserved.
//

#import "ViewController.h"
#import "ACDateTimePickTextField.h"
#import "LengthLimitedInputView.h"
#import "PickerTextField.h"
#import "NumericalInputTextField.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet LengthLimitedInputView *textLimitedTextField;
@property (weak, nonatomic) IBOutlet LengthLimitedInputView *textLimitedTextView;
@property (weak, nonatomic) IBOutlet NumericalInputTextField *decimalInputTextField;
@property (weak, nonatomic) IBOutlet NumericalInputTextField *decimalInputTextField1;
@property (weak, nonatomic) IBOutlet ACDateTimePickTextField *dateInputTextField;
@property (weak, nonatomic) IBOutlet PickerTextField *meunTextInputTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //限制长度的TextField输入
    __weak __typeof(self)weakSelf = self;
    self.textLimitedTextField.currentType = InputViewTypeTextField;
    self.textLimitedTextField.maxLengthOfInputText = 10;
    self.textLimitedTextField.font = [UIFont systemFontOfSize:15];
    self.textLimitedTextField.placeholder = @"输入姓名";
    self.textLimitedTextField.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@",[NSString stringWithFormat:@"真的是姓名吗？怎么会超过%@个字！",@(strongSelf.textLimitedTextField.maxLengthOfInputText)]);
    };
    //限制长度的TextView输入
    self.textLimitedTextView.currentType = InputViewTypeTextView;
    self.textLimitedTextView.maxLengthOfInputText = 20;
    self.textLimitedTextView.font = [UIFont systemFontOfSize:15];
    self.textLimitedTextView.placeholder = @"输入描述";
    self.textLimitedTextView.outOfLimitBlock = ^(id inputView){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@",[NSString stringWithFormat:@"描述文字不能超过%@个字！",@(strongSelf.textLimitedTextView.maxLengthOfInputText)]);
    };
    //限制输入数值的格式
    self.decimalInputTextField.inputTitle = @"请输入你的身高";
    self.decimalInputTextField.dataSourceDict = @{kIntegralPartDataSource:@[@[@"0",@"1",@"2",@"3"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]],
                                                  kFractionalPartDataSource:@[@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]]};
    self.decimalInputTextField1.inputTitle = @"请填写一个小于1的正小数";
    self.decimalInputTextField1.dataSourceDict = @{kFractionalPartDataSource:@[@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]],kIntegralPartDataSource:@[@[@"0"]]};
    //输入固定格式的日期（时间）
    self.dateInputTextField.font = [UIFont systemFontOfSize:17];
    self.dateInputTextField.inputPickerView.maximumDate = [NSDate distantFuture];
    self.dateInputTextField.inputPickerView.minimumDate = [NSDate distantPast];
    self.dateInputTextField.pickerMode = UIDatePickerModeDateAndTime;
    self.dateInputTextField.timeFormatterBlock = ^(NSDateFormatter *formatter){
        [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    };
    self.dateInputTextField.resultBlock = ^(NSDate *date,NSString *timeString){
        NSLog(@"选择的日期:%@",timeString);
    };
    //输入预先设定的字符串
    self.meunTextInputTextField.didSelectedResult = ^(NSString *title,NSInteger index){
        NSLog(@"blocker = %@",title);
    };
    self.meunTextInputTextField.dataSource = @[@"深圳",@"文字",@"空的腹"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
