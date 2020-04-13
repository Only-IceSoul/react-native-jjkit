#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>



@interface

RCT_EXTERN_MODULE(Toast,NSObject)


RCT_EXTERN_METHOD(show:(NSString *)message lenght:(NSInteger *)lenght)

@end

