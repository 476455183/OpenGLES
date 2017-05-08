//
//  OpenGLTool.h
//  OpenGL-Rectangle
//
//  Created by Mr_zhang on 17/4/12.
//  Copyright © 2017年 Mr_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface OpenGLTool : NSObject

+ (GLuint)loadProgramForVertexShaderPath:(NSString *)vertexShaderPath withFragmentShaderPath:(NSString *)fragmentShaderPath;

@end
