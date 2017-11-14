//
//  ColorDefine.h
//  Dingding
//
//  Created by 高 on 14-3-6.
//  Copyright (c) 2014年 高. All rights reserved.
//

#ifndef COLOR_DEFINE_H
#define COLOR_DEFINE_H


/**
 *  颜色16进制
 */
#define UICOLOR_FROM_RGB_OxFF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UICOLOR_FROM_RGB_OxFF_ALPHA(rgbValue,al)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

/**
 *  颜色RGB值
 */

#define UICOLOR_FROM_RGB(r,g,b)             [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define UICOLOR_FROM_RGB_ALPHA(r,g,b,al)             [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:al]


//cell 边线颜色
#define CELL_LINE_COLOR             UICOLOR_FROM_RGB_OxFF(0xf1f3f3)
#define LABLE_BLACK_COLOR           UICOLOR_FROM_RGB_OxFF(0x1d1d26)
#define LABLE_GRAY_COLOR            UICOLOR_FROM_RGB_OxFF(0xa7a7a7)

#define LABLE_3_BLACK_COLOR         UICOLOR_FROM_RGB_OxFF(0x333333)

#define LABLE_6_GRAY_COLOR          UICOLOR_FROM_RGB_OxFF(0x666666)
#define LABLE_7_GRAY_COLOR          UICOLOR_FROM_RGB_OxFF(0x777777)




#define LABLE_MORE_LIGHT_GRAY_COLOR UICOLOR_FROM_RGB_OxFF(0xcccccc)
#define LABLE_LIGHT_GRAY_COLOR      UICOLOR_FROM_RGB_OxFF(0x999999)

#define RED_COLOR                   UICOLOR_FROM_RGB_OxFF(0xfa5758)
#define YELLOW_COLOR                UICOLOR_FROM_RGB_OxFF(0xfed604)
#define LABLE_BROWN                 UICOLOR_FROM_RGB_OxFF(0x6d4113)

#define BLUE_COLOR                  UICOLOR_FROM_RGB_OxFF(0x00a0f4)

#define VIEW_BACK_COLOR             UICOLOR_FROM_RGB_OxFF(0xf0f0f0)

#define GOODS_SELECT_COLOR          UICOLOR_FROM_RGB(241, 82, 83)

#endif
