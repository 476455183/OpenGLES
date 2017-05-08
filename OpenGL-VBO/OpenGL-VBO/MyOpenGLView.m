//
//  MyOpenGLView.m
//  OpenGL-VBO
//
//  Created by Mr_zhang on 17/4/11.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "MyOpenGLView.h"
#import "OpenGLUtils.h"

@interface MyOpenGLView()
{
    EAGLContext *context;
    CAEAGLLayer *layer;
    
    GLuint renderBuffers;
    GLuint frameBuffers;
    
    GLuint postionSlot;
}

@end

@implementation MyOpenGLView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self setUpOpenGL];
        
        [self deleteRender];
        
        [self setUpBuffer];
        
        [self setUpProgram];
        
        [self render];
    }
    return self;
}

- (void)setUpOpenGL
{
   
    // 1.设置上下文
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context)
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!context)
        {
            NSLog(@"create context faile");
            return;
        }
    }
    if (![EAGLContext setCurrentContext:context])
    {
        NSLog(@"set up currentContext faile");
    }
    // 2.设置渲染图层
//    layer = (CAEAGLLayer *)self.layer;
//    layer.opaque = YES;// 是否透明
    layer = [CAEAGLLayer layer];
    layer.frame = self.frame;
    layer.opaque = NO;
    [self.layer addSublayer:layer];
    
    
}

- (void)setUpBuffer
{
    // 设置渲染缓冲对象
    glGenRenderbuffers(1, &renderBuffers);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffers);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    // 设置帧缓冲对象
    glGenFramebuffers(1, &frameBuffers);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffers);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffers);
}

- (void)setUpProgram
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertexShader" ofType:@"vsh"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader" ofType:@"fsh"];
    GLuint shaderProgram = [OpenGLUtils loadProgramForVertextShaderFilepath:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
    glUseProgram(shaderProgram);
    postionSlot = glGetAttribLocation(shaderProgram, "Position");
}

- (void)render
{
    glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    // 绑定vertexBuffer到GL_ARRAY_BUFFER目标
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    // 为VBO申请空间，初始化并传递数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // 使用VBO时，最后一个参数0为要获取参数在GL_ARRAY_BUFFER中的偏移量
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)deleteRender
{
    if (renderBuffers)
    {
        glDeleteRenderbuffers(1, &renderBuffers);
        renderBuffers = 0;
    }
    if (frameBuffers)
    {
        glDeleteFramebuffers(1, &frameBuffers);
        frameBuffers = 0;
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [EAGLContext setCurrentContext:context];
//    
//    [self deleteRender];
//    
//    [self setUpBuffer];
//    
//    [self render];
//}


@end
