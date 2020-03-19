//
//  KMHeader.h
//  Pods
//
//  Created by Ed on 2020/3/13.
//

#ifndef KMHeader_h
#define KMHeader_h
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KMTIMResource(name) [[NSBundle mainBundle] pathForResource:@"KMTIMImage" ofType:@"bundle"] == nil ? ([[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Frameworks/KMTIMSDK.framework/KMTIMImage.bundle"] stringByAppendingPathComponent:name]) : ([[[NSBundle mainBundle] pathForResource:@"KMTIMImage" ofType:@"bundle"] stringByAppendingPathComponent:name])

#endif /* KMHeader_h */
