//
//  CardHeader.h
//  CardAnimation
//
//  Created by 深圳市泥巴装网络科技有限公司 on 16/9/26.
//  Copyright © 2016年 马晓强. All rights reserved.
//

#ifndef CardHeader_h
#define CardHeader_h

#define iPhone5AndEarlyDevice (([[UIScreen mainScreen] bounds].size.height*[[UIScreen mainScreen] bounds].size.width <= 320*568)?YES:NO)
#define Iphone6 (([[UIScreen mainScreen] bounds].size.height*[[UIScreen mainScreen] bounds].size.width <= 375*667)?YES:NO)

static inline float lengthFit(float iphone6PlusLength){
    if (iPhone5AndEarlyDevice) {
        return iphone6PlusLength * 320.0f / 414.0f;
    }
    
    if (Iphone6) {
        return iphone6PlusLength * 375.0f / 414.0f;
    }
    return iphone6PlusLength;
    
}

#define PAN_DISTANCE 120
#define CARD_WIDTH lengthFit(333)
#define CARD_HEIGHT lengthFit(400)

#endif /* CardHeader_h */
