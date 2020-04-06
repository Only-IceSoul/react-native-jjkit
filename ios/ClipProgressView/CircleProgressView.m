//
//  CircleProgressView.m
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>


@interface
RCT_EXTERN_MODULE(CircleProgressView,RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(strokeWidth, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(colors, NSArray)
RCT_EXPORT_VIEW_PROPERTY(positions, NSArray)
RCT_EXPORT_VIEW_PROPERTY(backColors, NSArray)
RCT_EXPORT_VIEW_PROPERTY(backPositions, NSArray)

RCT_EXPORT_VIEW_PROPERTY(progress, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(cap, NSString)


@end
