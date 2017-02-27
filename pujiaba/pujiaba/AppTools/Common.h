//
//  Common.h
//  UITableViewPre
//
//  Created by zzzzz on 15/11/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define USERDEFAULT [NSUserDefaults standardUserDefaults]

/** 友盟appKey */
//#define UMSOCIALKEY @"507fcab25270157b37000010"//友盟测试key
#define UMSOCIALKEY @"56973d2be0f55aa4f30009b0"
/** 抽屉宽度 */
#define DRAWERWIDTH 180
/** 屏幕宽度 */
#define WIDTH [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define HEIGHT [UIScreen mainScreen].bounds.size.height
/** 屏幕尺寸 */
#define SIZE [UIScreen mainScreen].bounds.size
/** 屏幕大小 */
#define FULLSCREEN [UIScreen mainScreen].bounds
/** 状态栏和导航栏的高度 */
#define HEIGHTSTATUANDNAVB (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)

/** 用rgb创建颜色对象 0~255 */
#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

/** 生成一个随机的颜色 */
#define RANDOMCOLOR [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1]


/** 相对于父视图横向居中 结果是一个居中之后的CGRect结构体 */
#define HCENTER(p,s) CGRectMake((p.frame.size.width - s.frame.size.width) / 2, s.frame.origin.y, s.frame.size.width, s.frame.size.height)

/** 相对于父视图纵向向居中 结果是一个居中之后的CGRect结构体 */
#define VCENTER(p,s) CGRectMake(s.frame.origin.x, (p.frame.size.height - s.frame.size.height) / 2, s.frame.size.width, s.frame.size.height)

/** 相对于父视图居中 结果是一个居中之后的CGRect结构体 */
#define PCENTER(p,s) CGRectMake((p.frame.size.width - s.frame.size.width) / 2, (p.frame.size.height - s.frame.size.height) / 2, s.frame.size.width, s.frame.size.height)



/** 字典常用key */
#define FOCUS_LIST      @"foucs_list"
#define HOT_GAMES_LIST  @"hot_games_list"
#define NEW_GAMES_LIST  @"new_games_list"
#define HOT_TAGS_LIST   @"hot_tags_list"
#define GAMES_LIST      @"games_list"
#define TOPICS_LIST     @"topics_list"
#define TOPIC           @"topic"
#define POSTS_LIST      @"posts_list"
#define DATA            @"data"
#define GAME            @"game"
#define COMMENTS_LIST   @"comments_list"

/** 切换皮肤通知消息 */
#define CHANGE_SKIN     @"changeNightModel"


/** 当前皮肤配置key */
#define CURRENT_SKIN    @"currentSkin"


/** 请求网址 */
/** 官网网址 */
#define BASE_URL        @"http://www.pujia8.com/"
/** app主页网址 */
#define FOCUS_URL       @"http://www.pujia8.com/api/focus/"
/** game信息 */
#define INFO_URL        @"http://www.pujia8.com/api/gameinfo/"
/** commentsList */
#define COMMENTS_URL    @"http://www.pujia8.com/api/gamecomments/"
/** 游戏列表 */
#define GAMELIST_URL    @"http://www.pujia8.com/api/get_games_list2/"
/** 获取热门游戏列表 */
#define HOT_GAMELIST_URL @"http://www.pujia8.com/api/get_hot_games_list2/"
/** 话题列表链接 */
#define TOPICLIST_URL   @"http://www.pujia8.com/api/get_topics_list/"
/** 话题详细信息链接 */
#define TOPICINFO_URL   @"http://www.pujia8.com/api/topicinfo/"
/** 话题回复列表链接 */
#define TOPICCOMMENTSLIST_URL   @"http://www.pujia8.com/api/topiccomments/"
/** 图库游戏列表 */
#define GALLERYGAME_URL @"http://www.pujia8.com/api/gallery/"
/** 图库其他图片列表 */
#define GALLERYOTHER_URL @"http://www.pujia8.com/api/get_gallerys_tag/"
/** 搜索链接 */
#define SEARCH_URL      @"http://www.pujia8.com/api/game_search/"
/** 获得标签游戏链接 */
#define TAGGAME_URL     @"http://www.pujia8.com/api/get_games_tag/"

#endif /* Common_h */
