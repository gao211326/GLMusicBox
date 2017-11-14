//
//  GLMusicListViewController.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicListViewController.h"
#import "GLMusicPlayViewController.h"

#import "GLMusicPlayer.h"
#import "GLMiniMusicView.h"

@interface GLMusicListViewController ()

@property (nonatomic,strong) NSMutableDictionary *musicListDic;

@end

/*
 泡沫 http://mpge.5nd.com/2014/2014-12-29/65396/1.mp3
 白狐 http://mpge.5nd.com/2015/2015-5-6/66943/14.mp3
 新鸳鸯蝴蝶梦 http://mpge.5nd.com/h/200553/235016/858475.mp3
 小情歌    http://mpge.5nd.com/2006/s/200610233908150/39092153.mp3
 老人与海   http://mpge.5nd.com/2007/h/20075225298269/52989152.mp3
 美丽的神话 http://mpge.5nd.com/2005/s/2005920/995/3304410.mp3
 天使的翅膀  http://mpge.5nd.com/2009/2009a/x/24352/1.mp3
 */

@implementation GLMusicListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.musicListDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musiclist" ofType:@"plist"]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"播放列表";
    
    self.tableView.separatorColor = UICOLOR_FROM_RGB(45, 185, 105);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GLMiniMusicView shareInstance] showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicListDic.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musiclist" forIndexPath:indexPath];
    
    NSArray *musicTitles = self.musicListDic.allKeys;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = UICOLOR_FROM_RGB_OxFF(0x222222);
    cell.textLabel.text = musicTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[GLMiniMusicView shareInstance] hiddenView];
    
    GLMusicPlayViewController *playerVc = [[GLMusicPlayViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    [self presentViewController:playerVc animated:YES completion:^{
        
        NSMutableArray *musciList = [[NSMutableArray alloc] init];
        
        for (NSString *playUrl in weakSelf.musicListDic.allValues) {
            [musciList addObject:[NSURL URLWithString:playUrl]];
        }
        
        [GLMusicPlayer defaultPlayer].loopState = GLForeverLoop;
        [GLMusicPlayer defaultPlayer].musicListArray = musciList;
        [[GLMusicPlayer defaultPlayer] playMusicAtIndex:indexPath.row];
    }];
}


#pragma mark == 懒加载
- (NSMutableDictionary *)musicListDic
{
    if (nil == _musicListDic) {
        _musicListDic = [[NSMutableDictionary alloc] init];
    }
    return _musicListDic;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
