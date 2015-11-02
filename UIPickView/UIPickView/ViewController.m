//
//  ViewController.m
//  UIPickView
//
//  Created by xalo on 15/10/10.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>//PickerVier是具有系统级双协议的类 UIPickerViewDataSource提供数据支持, UIPickerViewDelegate 提供进行时方法的行为的实现
@property(nonatomic, retain)NSMutableArray *leftdataSource;//左侧数据
@property(nonatomic, retain)NSMutableArray *rightdataSource;//右侧联动数据
@property(nonatomic, retain)NSMutableArray *datasource;//右侧总数据

@property (retain, nonatomic) IBOutlet UIPickerView *pickView;
@property (retain, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController
- (void)dealloc
{    [_pickView release];
    [_datasource release];
    [_leftdataSource release];
    [_rightdataSource release];
    [_label release];
    [super dealloc];
}
//懒加载
- (NSMutableArray *)leftdataSource{
    if ( !_leftdataSource) {
        self.leftdataSource = [NSMutableArray array];
    }
    return _leftdataSource;
}
- (NSMutableArray *)rightdataSource{
    if (!_rightdataSource) {
        self.rightdataSource = [NSMutableArray array];
    }
    return _rightdataSource;
}
- (NSMutableArray *)datasource{
    if (!_datasource) {
        self.datasource = [NSMutableArray array];
        
    }
    return _datasource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置双协议的代理
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    //硬编码Plist解析
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    NSArray *contentArray = [NSArray arrayWithContentsOfFile:filePath ];
    for (NSDictionary *obj in contentArray) {
        [self.leftdataSource addObject:[obj valueForKey:@"State"]];
        [self.datasource addObject:[obj valueForKey:@"Cities"]];
    }
    //设置选中颜色  (在storyBoard中也可以设置)---但是貌似没效果
    self.pickView.showsSelectionIndicator = YES;

    //设置默认选中行(这里是第一次启动是的默认选中行的设置, 之后还有针对联动之后的数据展示做设置)
    [self.pickView selectRow:0 inComponent:1 animated:YES];
    [self.pickView selectRow:15 inComponent:0 animated:YES];
}

//必须实现的三个数据协议方法 datasource
//分栏数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//每个分栏下的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0 ) {
        return self.leftdataSource.count;
    }
    NSInteger province = [pickerView selectedRowInComponent:0];
    //关键点1 清空之前数据
//    self.rightdataSource = nil;
    [self.rightdataSource removeAllObjects];

    for (NSDictionary *city in self.datasource[province]) {
    [self.rightdataSource addObject:[city valueForKey:@"city"]];
    }
    return self.rightdataSource.count;
}

//每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //获取指定分栏的选中行号的方法
//    - (NSInteger)selectedRowInComponent:(NSInteger)component;

    if (component == 0 ) {
        //关键点二 联动更新 分栏一变化后对应的分栏二数据要改变
        NSInteger province = [pickerView selectedRowInComponent:0];
        //左侧改变 右侧全变
        [self.rightdataSource removeAllObjects];
        for (NSDictionary *city in self.datasource[province]) {
        [self.rightdataSource addObject:[city valueForKey:@"city"]];
            
        }
        [self.pickView reloadComponent:1];
        return self.leftdataSource[row];
//    }else{
//        self.rightdataSource = nil;
//        NSInteger province = [pickerView selectedRowInComponent:0];
//    for (NSDictionary *city in self.datasource[province]) {
//        [self.rightdataSource addObject:[city valueForKey:@"city"]];
//        }
    }
    return self.rightdataSource[row];
}

//功能实现的协议方法
//当选中行时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0 ) {
        NSInteger province = [pickerView selectedRowInComponent:0];
        for (NSDictionary *city in self.datasource[province]) {
            [self.rightdataSource addObject:[city valueForKey:@"city"]];
            //设置默认选中行
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            [self.pickView reloadComponent:1];
        }
        [pickerView reloadComponent:1];
        //获取被选中的不同分栏下单元的下标
        //数据获取展示
        NSInteger p = [self.pickView selectedRowInComponent:0];
        NSInteger c = [self.pickView selectedRowInComponent:1];
        self.label.text =[NSString stringWithFormat:@"%@%@", self.leftdataSource[p],self.rightdataSource[c]];
    }else{
    //获取被选中的不同分栏下单元的下标
    NSInteger p = [self.pickView selectedRowInComponent:0];
    NSInteger c = [self.pickView selectedRowInComponent:1];
    self.label.text =[NSString stringWithFormat:@"%@%@", self.leftdataSource[p],self.rightdataSource[c]];
    }
}
//设置定义的pickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UIView *aview = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 150, 50)] autorelease];
    aview.backgroundColor = [UIColor purpleColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"屏幕快照 2015-10-11 11.49.10.png"]];
      return image;
}


//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
