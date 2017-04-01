//
//  ViewController.m
//  FristOpenGLES_BuiltWindow
//
//  Created by Mr_zhang on 17/3/27.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "ViewController.h"
#import "MyOpenGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    MyOpenGLView *openGLView = [[MyOpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:openGLView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
