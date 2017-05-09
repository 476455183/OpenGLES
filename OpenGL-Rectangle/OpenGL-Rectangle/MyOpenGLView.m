//
//  MyOpenGLView.m
//  OpenGL-Rectangle
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "MyOpenGLView.h"
#import "OpenGLTool.h"
#import "OpenGLESUtils.h"

@interface MyOpenGLView()
{
    EAGLContext *context;
    CAEAGLLayer *eaglLayer;
    
    GLuint renderBuffer;
    GLuint frameBuffer;
    
    GLuint positionSlot;
    GLuint colorSlot;
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
        // 1.设置上下文
        [self setOpenGLContext];
        
        // 2.设置渲染图层
        [self setRenderLayer];
        
        // 3.设置渲染缓冲对象和帧缓冲对象
        [self setRenderBufferAndFrameBuffer];
        
        // 3.链接着色器程序
        [self setUpShaderProgram];
        
        // 4.渲染
        [self render];
    }
    return self;
}

- (void)setOpenGLContext
{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context)
    {
        NSLog(@"create context faile");
    }
    if (![EAGLContext setCurrentContext:context])
    {
        NSLog(@"set current context faile");
    }
}

- (void)setRenderLayer
{
    eaglLayer = [CAEAGLLayer layer];
    eaglLayer.frame = self.frame;
    eaglLayer.opaque = NO; // 是否透明
    [self.layer addSublayer:eaglLayer];
}

- (void)setUpShaderProgram
{
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertextShader" ofType:@"vsh"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragmentShader" ofType:@"fsh"];

    //GLuint shaderProgram = [OpenGLTool loadProgramForVertexShaderPath:vertexShaderPath withFragmentShaderPath:fragmentShaderPath];
    GLuint shaderProgram = [OpenGLESUtils loadProgram:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
    glUseProgram(shaderProgram);
    positionSlot = glGetAttribLocation(shaderProgram, "Position");
    colorSlot = glGetAttribLocation(shaderProgram, "SourceColor");
}

- (void)setRenderBufferAndFrameBuffer
{
    // destory renderBuffer and frameBuffer
    if (renderBuffer)
    {
        glDeleteBuffers(1, &renderBuffer);
        renderBuffer = 0;
    }
    if (frameBuffer)
    {
        glDeleteFramebuffers(1, &frameBuffer);
        frameBuffer = 0;
    }
    
    // create renderBuffer
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    // create frameBuffer
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, frameBuffer);
}

- (void)render
{
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 不使用VBO,不使用顶点索引数组(使用GL_TRIANGLE常规绘制，6个顶点)
    //[self nomalRenderRectangle];
    
    // 不使用VBO，不使用顶点索引数组(使用GL_TRIANGLE_STRIP绘制，4个顶点)
    //[self stripRenderRectangle];
    
    // 不使用VBO，不适用顶点索引数组(使用GL_TRIANGLE_FAN绘制，4个顶点)
     [self fanRenderRectangle];
    
    // 不使用VBO，使用顶点索引数组来绘制
    //[self useElementRenderRectangle];
    
    // 使用VBO + 顶点索引数组来绘制
    //[self useVBOandElementRenderRectangle];
}

- (void)nomalRenderRectangle
{
    const GLfloat vertices[] = {

        -1,-1, 0, // 左下，黑色
         1,-1, 0, // 右下，红色
        -1, 1, 0, // 左上，蓝色
        
         1,-1, 0, // 右下，红色
        -1, 1, 0, // 左上，蓝色
         1, 1, 0, // 右上，绿色
    };
    const GLfloat colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(positionSlot);
    
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorSlot);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)stripRenderRectangle
{
    const GLfloat vertices[] = {
       -1,-1, 0, // 左下，黑色 0
        1,-1, 0, // 右下，红色 1
       -1, 1, 0, // 左上，蓝色 2
        1, 1, 0, // 右上，绿色 3
    };
    const GLfloat colors[] = {
        1,0,0,1, // 右下，红色
        0,0,0,1, // 左下，黑色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(positionSlot);
    
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorSlot);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)fanRenderRectangle
{
    const GLfloat vertices[] = {
        1,-1, 0, // 右下，红色 1
       -1,-1, 0, // 左下，黑色 0
       -1, 1, 0, // 左上，蓝色 2
        1, 1, 0, // 右上，绿色 3
    };
    const GLfloat colors[] = {
        1,0,0,1, // 右下，红色
        0,0,0,1, // 左下，黑色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(positionSlot);
    
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorSlot);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)useElementRenderRectangle
{
    const GLfloat vertices[] = {
        -1,-1, 0,
         1,-1, 0,
        -1, 1, 0,
         1, 1, 0,
    };
    
    const GLfloat colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    const GLuint indexs[] = {
        0,1,2,
        1,2,3
    };
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(positionSlot);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorSlot);
    
    glDrawElements(GL_TRIANGLES, sizeof(indexs)/sizeof(indexs[0]), GL_UNSIGNED_INT, indexs);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    NSLog(@"sizeof(vertices):%lu  sizeof(vertices[0]):%lu ",sizeof(vertices),sizeof(vertices[0]));
    NSLog(@"sizeof(colors):%lu  sizeof(colors[0]):%lu ",sizeof(colors),sizeof(colors[0]));
    NSLog(@"sizeof(indexs):%lu  sizeof(indexs[0]):%lu ",sizeof(indexs),sizeof(indexs[0]));
}

typedef struct {
    float position[3];
    float colors[4];
}Vertex;

- (void)useVBOandElementRenderRectangle
{
    // 定义Vertex结构体
    const Vertex vertices[] = {
        {{-1,-1,0},{0,0,0,1}},
        {{ 1,-1,0},{1,0,0,1}},
        {{-1, 1,0},{0,1,0,1}},
        {{ 1, 1,0},{0,0,1,1}},
    };
    
    // 顶点索引数组
    const GLuint indices[] = {
        0,1,2,
        1,2,3
    };
    
    // set up VBO
    // GL_ARRAY_BUFFER 作用于顶点缓冲数组
    GLuint vertexBuffer;
    // 创建VBO
    glGenBuffers(1, &vertexBuffer);
    // 绑定VBO
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    // 为VBO申请内存空间，并初始化内存数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // GL_ELEMENT_ARRAY_BUFFER 作用于顶点索引数组
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glEnableVertexAttribArray(positionSlot);
    
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(float) * 7, (GLvoid *)(sizeof(float)*3));
    glEnableVertexAttribArray(colorSlot);
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_INT, 0);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    NSLog(@"sizeof(Vertex):%lu  sizeof(vertices):%lu sizeof(indices[0]):%lu  sizeof(float):%lu",sizeof(Vertex),sizeof(vertices),sizeof(indices[0]),sizeof(float));
    
}

@end
