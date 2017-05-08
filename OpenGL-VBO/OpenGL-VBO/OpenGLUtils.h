//
//  OpenGLUtils.h
//  OpenGL-VBO
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface OpenGLUtils : NSObject

+ (GLuint)loadProgramForVertextShaderFilepath:(NSString *)vertexShaderPath withFragmentShaderFilepath:(NSString *)fragmentShaderPath;

@end
