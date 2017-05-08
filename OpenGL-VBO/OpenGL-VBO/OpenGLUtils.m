//
//  OpenGLUtils.m
//  OpenGL-VBO
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import "OpenGLUtils.h"

@implementation OpenGLUtils

+ (GLuint)loadShaderProgram:(GLenum)type withShaderFilePath:(NSString *)shaderPath
{
    NSString *shaderStr = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:nil];
    
    return [OpenGLUtils loadShader:type withShaderString:shaderStr];
}

+ (GLuint)loadShader:(GLenum)type withShaderString:(NSString *)shaderStr
{
    GLuint shader = glCreateShader(type);
    const char *shaderStringUTF8 = [shaderStr UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    glCompileShader(shader);
    return shader;
}

+ (GLuint)loadProgramForVertextShaderFilepath:(NSString *)vertexShaderPath withFragmentShaderFilepath:(NSString *)fragmentShaderPath
{
    // create vertexShader
    GLuint vertexShader = [OpenGLUtils loadShaderProgram:GL_VERTEX_SHADER withShaderFilePath:vertexShaderPath];
    // create fragmentshader
    GLuint fragmentShader = [OpenGLUtils loadShaderProgram:GL_FRAGMENT_SHADER withShaderFilePath:fragmentShaderPath];
    
    GLuint shaderProgram = glCreateProgram();
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return shaderProgram;
}
@end
