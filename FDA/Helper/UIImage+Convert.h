//
//  UIImage+Convert.h
//  Image Recognition
//
//  Created by Mahendar on 8/6/17.
//  Copyright © 2017 Mahendar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>


@interface UIImage (Convert)
+ (UIImage *) image1FromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
- (UIImage *)imageRotatedByDegrees:(double)degrees mirror:(BOOL)mirror;
- (CGFloat)alphaAtPosition:(CGPoint)position;
- (UIImage *)flipImage:(UIImage *)image;
-(UIImage*) cropinRect:(CGRect)rect;
@end
