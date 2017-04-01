//
//  MyOpenGLView.m
//  FristOpenGLES_BuiltWindow
//
//  Created by Mr_zhang on 17/3/27.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "MyOpenGLView.h"
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>

@interface MyOpenGLView()
{
    EAGLContext *context;
}

@end

@implementation MyOpenGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self setUpOpenGL];
    }
    return self;
}

- (void)setUpOpenGL
{
    // 1.设置上下文 (set up context)
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context)
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    if (![EAGLContext setCurrentContext:context])
    {
        NSLog(@"setting currentContext faile");
        return;
    }
    
    // 2.渲染的图层layer（rendering layer）
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = YES;// 是否透明
    layer.contentsScale = [UIScreen mainScreen].scale;// 设备的分辨率
    
    // 3.配置渲染缓冲区 (configurate render buffer)
    GLuint renderBuffer;
    //创建一个渲染缓冲区对象
    glGenRenderbuffers(1, &renderBuffer);
    //将该渲染缓冲区对象绑定到管线上
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];

    // 4.配置帧缓冲区 (configurate frame buffer)
    GLuint frameBuffer;
    //创建一个帧染缓冲区对象
    glGenFramebuffers(1, &frameBuffer);
    //将该帧染缓冲区对象绑定到管线上
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    //将创建的渲染缓冲区绑定到帧缓冲区上，并使用颜色填充
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, frameBuffer);
    
    // 5.配置清空屏幕所用的颜色 (configurate clear buffer color)
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == context)
    {
        [EAGLContext setCurrentContext:nil];
    }
}

@end
