//
//  OpenGLTool.m
//  OpenGL-Rectangle
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "OpenGLTool.h"

@implementation OpenGLTool

+ (GLuint)loadShaderProgram:(GLenum)type withShaderFilePath:(NSString *)vertexShaderPath
{
    NSError *error;
    NSString *shaderStr = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderStr)
    {
        NSLog(@"the error is :%@",error.localizedDescription);
        return 0;
    }
    return [self loadShaderProgram:type withShaderFilePath:shaderStr];
}

+ (GLuint)loadShader:(GLenum)type withShaderStr:(NSString *)shaderStr
{
    const char *shaderStrUTF8 = [shaderStr UTF8String];
    GLuint shader = glCreateShader(type);
    glShaderSource(shader, 1, &shaderStrUTF8, NULL);
    glCompileShader(shader);
    return shader;
}

+ (GLuint)loadProgramForVertexShaderPath:(NSString *)vertexShaderPath withFragmentShaderPath:(NSString *)fragmentShaderPath
{
    GLuint vertextShader = [OpenGLTool loadShaderProgram:GL_VERTEX_SHADER withShaderFilePath:vertexShaderPath];
    GLuint fragmentShader = [OpenGLTool loadShaderProgram:GL_FRAGMENT_SHADER withShaderFilePath:fragmentShaderPath];
    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertextShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    glDeleteShader(vertextShader);
    glDeleteShader(fragmentShader);
    return shaderProgram;
    
}

@end
