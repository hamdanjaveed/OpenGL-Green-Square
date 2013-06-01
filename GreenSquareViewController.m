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
@end

@implementation GreenSquareViewController

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
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

# pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.0, 100.0/255.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)update {
    
}

@end
