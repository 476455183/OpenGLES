//
//  ViewController.m
//  OpenGL_ Triangle
//
//  Created by Mr_zhang on 17/3/29.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "ViewController.h"
#import "MyOpenGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyOpenGLView *view = [[MyOpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    
}


@end
