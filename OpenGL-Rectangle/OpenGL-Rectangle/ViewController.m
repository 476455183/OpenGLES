//
//  ViewController.m
//  OpenGL-Rectangle
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "ViewController.h"
#import "MyOpenGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyOpenGLView *openGLView = [[MyOpenGLView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:openGLView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
