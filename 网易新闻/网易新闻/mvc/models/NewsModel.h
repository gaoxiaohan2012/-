//
//  NewsModel.h
//  网易新闻
//
//  Created by MS on 15/10/15.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic,copy) NSString *alias;
@property (nonatomic,strong) NSArray *adsArray;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *imgsrc;
@property (nonatomic,copy) NSString *lmodify;//也是时间
@property (nonatomic,copy) NSString *photosetID;
@property (nonatomic,copy) NSString *priority;//优先权
@property (nonatomic,copy) NSString *ptime;//时间
@property (nonatomic,copy) NSString *replyCount;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *tname;
@property (nonatomic,copy) NSString *digest;
@property (nonatomic,copy) NSString *url_3w;
@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) NSArray *imgextraArr;//图片

@end
