//
//  ODDViewSizeConstants.h
//  Happyness
//
//  Created by Yujun Cho on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#ifdef IS_IPHONE_5
#define SCROLLVIEW_HEIGHT_RATIO     3.3/5
#else
#define SCROLLVIEW_HEIGHT_RATIO     3.5/5
#endif

#define TOP_HEIGHT_RATIO            3.4/5
#define PAGECONTROL_HEIGHT          15