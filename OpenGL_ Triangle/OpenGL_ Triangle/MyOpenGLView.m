//
//  MyOpenGLView.m
//  OpenGL_ Triangle
//
//  Created by Mr_zhang on 17/4/6.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "MyOpenGLView.h"
#import "OpenGLESUtils.h"

@interface MyOpenGLView ()
{
    EAGLContext *context;
    CAEAGLLayer *layer;
    
    GLuint renderBuffer;
    GLuint frameBuffer;
    
    GLuint shaderProgram;
    GLuint positionSlot;
}
@end

@implementation MyOpenGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        // 1.设置渲染图层
        [self setUpLayer];
        // 2.设置上下文
        [self setUpOpenGLESContext];
        // 3.配置渲染缓冲区和帧缓冲区
        [self setUpRenderAndFrameBuffer];
        // 4.配置着色器程序
        [self setUpShaderProgram];
        
    }
    return self;
}

// 1.设置渲染图层
- (void)setUpLayer
{
    layer = (CAEAGLLayer *)self.layer;
    layer.opaque = NO;
    //layer.contentsScale = [UIScreen mainScreen].scale;
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

// 2.设置上下文
- (void)setUpOpenGLESContext
{
    // 指定 OpenGL 渲染的 API 版本，这里我们使用OpenGL ES 3.0,创建失败在选择2.0
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if(!context)
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    // 设置上下文
    if(![EAGLContext setCurrentContext:context])
    {
        NSLog(@"setting current context faile");
        return;
    }
}

// 3.配置渲染缓冲区和帧缓冲区
- (void)setUpRenderAndFrameBuffer
{
    // 3.设置渲染缓冲区
    // 创建一个渲染缓冲区对象
    glGenRenderbuffers(1, &renderBuffer);
    // 将渲染缓冲区对象绑定在管线上
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    // 通知上下文context让CAEAGLLayer实例分配内存空间，用于保存后续绘制的内容
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    // 4设置帧缓冲区
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, frameBuffer);
}

// 删除缓冲区缓存
- (void)deleteBuffer
{
    glDeleteRenderbuffers(1, &renderBuffer);
    renderBuffer = 0;
    glDeleteFramebuffers(1, &frameBuffer);
    frameBuffer = 0;
}

// 创建着色器程序（顶点着色器和片段着色器）
- (void)setUpShaderProgram
{
    // 创建顶点着色器
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertextShader" ofType:@"vsh"];
    // 创建片段着色器
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader" ofType:@"fsh"];
    // 创建着色器程序
    shaderProgram = [OpenGLESUtils loadProgram:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
    // 检验着色器是否创建成功
    if (shaderProgram == 0)
    {
        NSLog(@"faile to set up shaderProgram");
        return;
    }
    // 激活着色器程序
    glUseProgram(shaderProgram);
    // 获取坐标位置
    positionSlot = glGetAttribLocation(shaderProgram, "vPosition");
}

// 渲染
- (void)render
{
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat verteices[] = {
        0.0f,  0.5f,  0.0f,
        -0.5f, -0.5f,  0.0f,
        0.5f, -0.5f,  0.0f
    };
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, verteices);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [EAGLContext setCurrentContext:context];
    
    [self deleteBuffer];
    
    [self setUpRenderAndFrameBuffer];
    
    [self render];
}




@end
