#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTBridgeModule.h>


@interface
RCT_EXTERN_MODULE(Badge,RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(text, NSString)
RCT_EXPORT_VIEW_PROPERTY(textSize, CGFloat)

RCT_EXPORT_SHADOW_PROPERTY(text, NSString)
RCT_EXPORT_SHADOW_PROPERTY(textSize, CGFloat)

RCT_EXPORT_VIEW_PROPERTY(insetX, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(insetY, CGFloat)
RCT_EXPORT_SHADOW_PROPERTY(insetX, CGFloat)
RCT_EXPORT_SHADOW_PROPERTY(insetY, CGFloat)

RCT_EXPORT_VIEW_PROPERTY(font, NSString)
RCT_EXPORT_VIEW_PROPERTY(textColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(strokeColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(strokeWidth, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(isTextHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(textOffsetX, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(textOffsetY, CGFloat)

@end
