//
//  NSObject_Function.h
//  MoiveTickets
//
//  Created by 高 on 14-8-14.
//  Copyright (c) 2014年 高. All rights reserved.
//

#import <Foundation/Foundation.h>


#define APP ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define CURRENT_VIEW_WIDTH                          self.view.frame.size.width
#define CURRENT_VIEW_HEIGTH                         self.view.frame.size.height

#define CURRENT_FRAME_WIDTH                         self.frame.size.width
#define CURRENT_FRAME_HEIGTH                        self.frame.size.height

#define kScreenSize                                 [UIScreen mainScreen].bounds
#define kScreenWidth                                kScreenSize.size.width
#define kScreenHeight                               kScreenSize.size.height

//设置default
#define KEY_IN_USERDEFAULT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define KEY_IN_USERDEFAULT_BOOL(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define  SET_OBJ_FOR_KEY_IN_USERDEFAULT(_obj_,_key_) [[NSUserDefaults standardUserDefaults] setObject:_obj_ forKey:_key_]
#define  SET_VALUE_FOR_KEY_IN_USERDEFAULT(_value_,_key_) [[NSUserDefaults standardUserDefaults] setValue:_value_ forKey:_key_]
#define  SET_BOOL_FOR_KEY_IN_USERDEFAULT(_bool_,_key_) [[NSUserDefaults standardUserDefaults] setBool:_bool_ forKey:_key_]

#define  SET_SYNCHRONIZE(_synchronize) [[NSUserDefaults standardUserDefaults] _synchronize]



//Ios7+
#define IOS7 ([[UIDevice currentDevice].systemVersion integerValue]>=7.0f)

//Ios8+
#define IOS8 ([[UIDevice currentDevice].systemVersion integerValue]>=8.0f)


#define  GET_IMAGE_WITH_NAME_AND_TYPE(name,type)  \
[UIImage imageWithContentsOfFile:\
[[NSBundle mainBundle]\
pathForResource:name ofType:type]]

#define  GET_IMAGE_WITH_NAME(name)  \
[UIImage imageWithContentsOfFile:\
[[NSBundle mainBundle]\
pathForResource:name ofType:@"png"]]

