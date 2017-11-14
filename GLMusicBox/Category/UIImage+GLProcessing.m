//
//  UIImage+GLProcessing.m
//  UIImageOperationDemo
//
//  Created by 高磊 on 2017/4/12.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "UIImage+GLProcessing.h"
#import <ImageIO/ImageIO.h>


@implementation UIImage (GLProcessing)

+ (UIImage*)gl_circleImage:(UIImage*)image withBorder:(CGFloat)border color:(UIColor *)color
{
    //通过自己创建一个context来绘制,通常用于对图片的处理
    //在retian屏幕上要使用这个函数，才能保证不失真
    //该函数会自动创建一个context，并把它push到上下文栈顶，坐标系也经处理和UIKit的坐标系相同
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //设置宽度
    CGContextSetLineWidth(context, 4*border);
    //设置边框颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    //画椭圆 当宽和高一样的时候 为圆 此处设置可视范围
    CGContextAddEllipseInRect(context, rect);
    //剪切可视范围
    CGContextClip(context);

    //绘制图片
    [image drawInRect:rect];

    CGContextAddEllipseInRect(context, rect);
    // 绘制当前的路径 只描绘边框
    CGContextStrokePath(context);

    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)gl_circleImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

    //画椭圆 当宽和高一样的时候 为圆
    CGContextAddEllipseInRect(context, rect);
    //剪切可视范围
    CGContextClip(context);
    
    //绘制图片
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)gl_imageWithColor:(UIColor *)color size:(CGSize)size{
    CGSize imageSize = size;
    //通过自己创建一个context来绘制，通常用于对图片的处理
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    //直接按rect的范围覆盖
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)gl_circleImageWithColor:(UIColor *)color radius:(CGFloat)radius
{
    CGSize imageSize = CGSizeMake(radius, radius);
    //通过自己创建一个context来绘制，通常用于对图片的处理
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    //用当前的填充颜色或样式填充路径线段包围的区域
    CGContextFillPath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)gl_cornerImage:(UIImage*)image corner:(CGFloat)corner rectCorner:(UIRectCorner)rectCorner
{
    CGSize imageSize = image.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0,
                             0,
                             imageSize.width,
                             imageSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:rectCorner
                                                     cornerRadii:CGSizeMake(corner,
                                                                            corner)];
    //添加路径
    CGContextAddPath(context, [path CGPath]);
    //剪切可视范围
    CGContextClip(context);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize maxSizeWithKB:(CGFloat)maxSizeKB
{    
    if (maxSize <= 0) {
        return nil;
    }
    
    if (maxSizeKB <= 0) {
        return nil;
    }

    CGSize compressSize = image.size;
    //获取缩放比 进行比较 
    CGFloat widthScale = compressSize.width*1.0 / maxSize;
    CGFloat heightScale = compressSize.height*1.0 / maxSize;
    
    if (widthScale > 1 && widthScale > heightScale) {
        compressSize = CGSizeMake(image.size.width/widthScale, image.size.height/widthScale);
    }
    else if (heightScale > 1 && heightScale > widthScale){
        compressSize = CGSizeMake(image.size.width/heightScale, image.size.height/heightScale);
    }
    
    //创建图片上下文 并获取剪切尺寸后的图片
    UIGraphicsBeginImageContextWithOptions(compressSize, NO, 1);
    CGRect rect = {CGPointZero,compressSize};
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //循环缩小图片大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);
    //获取当前图片的大小
    CGFloat currentImageSizeOfKB = imageData.length/1024.0;
    
    //压缩比例
    CGFloat compress = 0.9;
    
    while (currentImageSizeOfKB > maxSizeKB && compress > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage, compress);
        currentImageSizeOfKB = imageData.length/1024.0;
        compress -= 0.1;
    }
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize
{
    if (maxSize <= 0) {
        return nil;
    }
    
    CGSize compressSize = image.size;
    //获取缩放比 进行比较
    CGFloat widthScale = compressSize.width*1.0 / maxSize;
    CGFloat heightScale = compressSize.height*1.0 / maxSize;
    
    if (widthScale > 1 && widthScale > heightScale) {
        compressSize = CGSizeMake(image.size.width/widthScale, image.size.height/widthScale);
    }
    else if (heightScale > 1 && heightScale > widthScale){
        compressSize = CGSizeMake(image.size.width/heightScale, image.size.height/heightScale);
    }
    
    //创建图片上下文 并获取剪切尺寸后的图片
    UIGraphicsBeginImageContextWithOptions(compressSize, NO, 1);
    CGRect rect = {CGPointZero,compressSize};
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark == GIF图片
+ (UIImage *)gl_animateGIFWithImagePath:(NSString *)imagePath
{
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (!data) {
        return nil;
    }
    
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //得到图片资源的数量
    size_t imageCount = CGImageSourceGetCount(imageSource);
    //如果只有一张图片 则返回
    if (imageCount <= 1) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        
        return resultImage;
    }
    
    return animatedImageWithAnimateImageSource(imageSource);
}

+ (UIImage *)gl_animateGIFWithImageData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //得到图片资源的数量
    size_t imageCount = CGImageSourceGetCount(imageSource);
    //如果只有一张图片 则返回
    if (imageCount <= 1) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        
        return resultImage;
    }
    
    return animatedImageWithAnimateImageSource(imageSource);
}

+ (UIImage *)gl_animateGIFWithImageUrl:(NSURL *)url
{
    if (!url) {
        return nil;
    }
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
      
    return animatedImageWithAnimateImageSource(imageSource);
}

//动态图片处理
static UIImage *animatedImageWithAnimateImageSource(CGImageSourceRef imageSource)
{
    if (imageSource) {
        //得到图片资源的数量
        size_t imageCount = CGImageSourceGetCount(imageSource);
        
        //最终图片资源
        UIImage *resultImage = nil;
        
        //动态图片时间
        NSTimeInterval duration = 0.0;
        //取图片资源
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
        
        for (size_t i = 0; i < imageCount; i ++) {
            //此处用到了create  后面记得释放
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            
            if (cgImage) {
                //将图片加入到数组中
                [images addObject:[UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            }
            
            duration += frameDuration(i, imageSource);
            
            //释放掉 不然会内存泄漏
            CGImageRelease(cgImage);
        }
        
        if (duration == 0.0) {
            duration = 0.1 * imageCount;
        }
        
        
        resultImage = [UIImage animatedImageWithImages:images duration:duration];
        
        CFRelease(imageSource);
        
        return resultImage;
    }
    return nil;
}

static CGFloat frameDuration(NSInteger index,CGImageSourceRef source)
{
    //获取每一帧的信息
    CFDictionaryRef frameProperties = CGImageSourceCopyPropertiesAtIndex(source,index, nil);
    //转换为dic
    NSDictionary *framePropertiesDic = (__bridge NSDictionary *)frameProperties;
    //获取每帧中关于GIF的信息
    NSDictionary *gifProperties = framePropertiesDic[(__bridge NSString *)kCGImagePropertyGIFDictionary];
    /*
     苹果官方文档中的说明
     kCGImagePropertyGIFDelayTime
     The amount of time, in seconds, to wait before displaying the next image in an animated sequence
     
     kCGImagePropertyGIFUnclampedDelayTime
     The amount of time, in seconds, to wait before displaying the next image in an animated sequence. This value may be 0 milliseconds or higher. Unlike the kCGImagePropertyGIFDelayTime property, this value is not clamped at the low end of the range.
     
     看了翻译瞬间蒙了 感觉一样 但是kCGImagePropertyGIFDelayTime 可能为0  所以我觉得可以先判断kCGImagePropertyGIFDelayTime
     */
    CGFloat duration = 0.1;
    
    NSNumber *unclampedPropdelayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    NSNumber *delayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFDelayTime];
    
    if (unclampedPropdelayTime) {
        duration = unclampedPropdelayTime.floatValue;
    }else{
        if (delayTime) {
            duration = delayTime.floatValue;
        }
    }
    
    CFRelease(frameProperties);
    
    return duration;
}


#pragma mark == 添加文字 截屏 擦除

+ (UIImage *)gl_addTitleAboveImage:(UIImage *)image addTitleText:(NSString *)text
                   attributeDic:(NSDictionary *)attributeDic point:(CGPoint)point
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [image drawInRect:imageRect];
    
    [text drawAtPoint:point withAttributes:attributeDic];
    
    //获取上下文中的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)gl_addAboveImage:(UIImage *)image addImage:(UIImage *)addImage rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [image drawInRect:imageRect];
    
    [addImage drawInRect:rect];
    
    //获取上下文中的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)gl_snapScreenView:(UIView *)view
{
    //开启上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //渲染图片
    [view.layer renderInContext:context];
    //得到新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //避免内存泄漏
    view.layer.contents = nil;
    
    return newImage;
}

+ (UIImage *)gl_wipeImageWithView:(UIView *)view movePoint:(CGPoint)point brushSize:(CGSize)size
{
    //开启上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //此方法不能渲染图片 只针对layer
    //[view.layer drawInContext:context];
    
    //以point为中心，然后size的一半向两边延伸  坐画笔  橡皮擦
    CGRect clearRect = CGRectMake(point.x - size.width/2.0, point.y - size.width/2.0, size.width, size.height);
    
    //渲染图片
    [view.layer renderInContext:context];
    //清除该区域
    CGContextClearRect(context, clearRect);
    //得到新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    //避免内存泄漏
    view.layer.contents = nil;
    
    return newImage;
}

@end
