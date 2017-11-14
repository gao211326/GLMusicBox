//
//  UIImage+GLProcessing.h
//  UIImageOperationDemo
//
//  Created by 高磊 on 2017/4/12.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图片处理
 */
@interface UIImage (GLProcessing)


/**
 创建带有外围圈的圆圈图片

 @param image 原始图片
 @param border 图片外边框
 @param color 外围圆圈颜色
 @return 返回裁剪后的图片
 */
+ (UIImage*)gl_circleImage:(UIImage*)image withBorder:(CGFloat)border color:(UIColor*)color;


/**
 创建圆形图片

 @param image 原始图片
 @return 返回
 */
+ (UIImage *)gl_circleImage:(UIImage *)image;

/**
 根据颜色创建图片 （矩形）

 @param color 颜色
 @param size 图片大小
 @return 返回生成后的图片
 */
+ (UIImage *)gl_imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 根据颜色返回圆形图片

 @param color 颜色
 @param radius 图片的半径
 @return 返回生成后的图
 */
+ (UIImage *)gl_circleImageWithColor:(UIColor *)color radius:(CGFloat)radius;


/**
 给图片设置圆角

 @param image 原生图片
 @param corner 圆角大小
 @param rectCorner 圆角的位置
 @return 返回生成后的图片
 */
+ (UIImage*)gl_cornerImage:(UIImage*)image corner:(CGFloat)corner rectCorner:(UIRectCorner)rectCorner;


/**
 压缩图片

 @param image 原始图片
 @param maxSize 压缩图片的最大尺寸 宽或者长中最大的
 @param maxSizeKB 压缩后的最大大小 KB
 @return 返回压缩后的图片
 */
+ (UIImage *)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize maxSizeWithKB:(CGFloat)maxSizeKB;


/**
 压缩图片

 @param image 原始图片
 @param maxSize 压缩图片的最大尺寸 宽或者长中最大的
 @return 返回压缩后的图片
 */
+ (UIImage *)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize;

/**
 加载动态gif图片

 @param imagePath gif图片路径 
 @return 返回
 */
+ (UIImage *)gl_animateGIFWithImagePath:(NSString *)imagePath;


/**
 加载动态gif图片

 @param data 动态图片的data
 @return 返回
 */
+ (UIImage *)gl_animateGIFWithImageData:(NSData *)data;


/**
 加载动态gif图片

 @param url 图片的url地址
 @return 返回
 */
+ (UIImage *)gl_animateGIFWithImageUrl:(NSURL *)url;



/**
 在图片上添加文字
 @param image 图片
 @param text 文字信息
 @param attributeDic 文字的详细信息 如大小颜色等
 @param point 坐标
 @return 返回添加文字后的图片
 */
+ (UIImage *)gl_addTitleAboveImage:(UIImage *)image addTitleText:(NSString *)text attributeDic:(NSDictionary *)attributeDic point:(CGPoint)point;



/**
 将图片添加到图片上

 @param image 被添加的图片
 @param addImage 将要添加的图片
 @param rect 将要添加的图片在被添加的图片上的坐标
 @return 返回
 */
+ (UIImage *)gl_addAboveImage:(UIImage *)image addImage:(UIImage *)addImage rect:(CGRect)rect;


/**
 截屏

 @param view 当前view
 @return 返回图片
 */
+ (UIImage *)gl_snapScreenView:(UIView *)view;

/**
 擦除图片

 @param view 被擦除的view
 @param point 擦除位置坐标
 @param size 画笔的大小
 @return 返回擦除后的图片
 */
+ (UIImage *)gl_wipeImageWithView:(UIView *)view movePoint:(CGPoint)point brushSize:(CGSize)size;


@end
