//
//  OpenGLESUtils.h
//  OpenGL_ Triangle
//
//  Created by Mr_zhang on 17/4/7.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface OpenGLESUtils : NSObject

+ (GLuint)loadProgram:(NSString *)vertexShaderFilepath withFragmentShaderFilepath:(NSString *)fragmentShaderFilepath;

@end
