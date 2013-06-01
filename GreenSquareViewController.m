//
//  GreenSquareViewController.m
//  Green Square
//
//  Created by Hamdan Javeed on 2013-06-01.
//  Copyright (c) 2013 Glass Cube. All rights reserved.
//

#import "GreenSquareViewController.h"

@interface GreenSquareViewController ()
// an OpenGL ES context that is used for drawing
@property (strong, nonatomic) EAGLContext *context;

GLuint _vertexBuffer;
GLuint _indexBuffer;
@end

@implementation GreenSquareViewController

- (void)setupGL {
    // set the current context
    [EAGLContext setCurrentContext:self.context];
    
    // create a new vertex buffer object
    glGenBuffers(1, &_vertexBuffer);
    // when I say 'GL_ARRAY_BUFFER', I really mean '_vertexBuffer'
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    // send OpenGL the data in this buffer
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize an OpenGL ES 2.0 context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create an ES context");
    }
    
    // associate the context with our view
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    [self setupGL];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self tearDownGL];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

# pragma mark - GLKViewDelegate

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices [] = {
    0, 1, 2,
    2, 3, 0
};

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 250.0/255.0, 240.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

- (void)update {
    
}

@end
