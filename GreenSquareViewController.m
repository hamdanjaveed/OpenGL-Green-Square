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

@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation GreenSquareViewController

float _rotation;
GLuint _vertexBuffer;
GLuint _indexBuffer;

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 2}, {0, 0.8, 0, 1}},
    {{1, 1, 0}, {0, 0.8, 0, 1}},
    {{-1, 1, 0}, {0, 0.8, 0, 1}},
    {{-1, -1, 0}, {0, 0.8, 0, 1}}
};

const GLubyte Indices [] = {
    0, 1, 2,
    2, 3, 0
};

- (void)setupGL {
    // set the current context
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    
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
    
    self.effect = nil;
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
    return UIInterfaceOrientationMaskAll;
}

# pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // prepare the effect to draw
    [self.effect prepareToDraw];
    
    // tell OpenGL which vertex buffers to use
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    // enable the predefined vertex attributes we want GLKBaseEffect to use, this one is the vertex postion
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // feed correct input values for the vertex shader
    // The parameters are as follows:
    // 1) the attribute name to set
    // 2) how many values are present for each vertex (position = 3, color = 4)
    // 3) the type of values, GL_FLOAT in our case
    // 4) false ... lol
    // 5) the offset within a struct to find the particular data
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
    
    // draw the square
    // The parameters are as follows:
    // 1) the manner of drawing the vertices (GL_LINE_STRIP, GL_TRIANGLE_FAN, GL_TRIANGLES etc)
    // 2) the count of the vertices to render, below is a C trick to compute the number of elements in an array (sizeof array in bytes / sizeof element in bytes)
    // 3) the data type of each individual index, we are using an unsigned byte
    // 4) should be a pointer to an array of indices, but not when we're using VBO's
    glDrawElements(GL_TRIANGLES, sizeof(Indices) / sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)update {
    // get the aspect ratio of the view
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    // use a built in helper function to create a perspective matrix
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);
    // set the effect's transform property to our projection matrix
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // move 6 units backwards (the square has a z-value of 0, and since the near plane is 4, we need to move back to see it)
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

@end
