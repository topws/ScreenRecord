//
//  GameScreenRecoder.h
//  ScreenRecoderForGame
//
//  Created by qianwei on 16/4/21.
//  Copyright © 2016年 qianwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
@protocol GameScreenRecoderDelegate <NSObject>

@required
//预览准备的视频
-(void)showSuccessViewController;
//点击取消或者村村后要移除这个页面
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController;
//根据需要进行用户提示
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes;

@optional
//正在录屏
-(void)loading;
//结束录屏
-(void)loadEnd;
@end

@interface GameScreenRecoder : NSObject

@property(nonatomic,weak)id <GameScreenRecoderDelegate,RPPreviewViewControllerDelegate> delegate;
+(instancetype)INSTANCE;

//开始录屏是否需要启用麦克风
+(BOOL)startRecord:(BOOL)isNeedMicroPhone;
+(void)stopRecord;
@end
