//
//  ViewController.m
//  TPasterView
//
//  Created by Pan on 2017/12/13.
//  Copyright © 2017年 Pan. All rights reserved.
//

#import "ViewController.h"
#import "XTPasterView.h"
@interface ViewController ()
@property(nonatomic,strong)XTPasterView * pasterView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.pasterView = [[XTPasterView alloc]initWithBgView:CGRectMake(100, 100, 100, 100)  isImage:YES];
//    self.pasterView.image = [UIImage imageNamed:@"dogs"];
//    [self.view addSubview:self.pasterView];
     self.pasterView = [[XTPasterView alloc]initWithBgView:CGRectMake(100, 100, 100, 50)  isImage:NO];
    self.pasterView.currentStr = @"sssss";
    [self.view addSubview:self.pasterView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.pasterView.isOnFirst = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
