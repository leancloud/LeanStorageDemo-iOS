//
//  AVFileBasic.m
//  AVOSDemo
//
//  Created by Travis on 13-12-12.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVFileBasic.h"
#import "ImageViewController.h"

@implementation AVFileBasic

-(void)demoCreateFile{
    //获取要保存的数据
    NSData *data=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cloud" ofType:@"png"]];
    
    //用数据创建文件
    AVFile *file=[AVFile fileWithName:@"cloud.png" data:data];
    
    //保存文件
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self log:[NSString stringWithFormat:@"文件已经保存到服务器:[%@] %@",file.objectId,file.url]];
        }else {
            [self log:[error description]];
        }
    }];
}

-(void)demoFromPathCreateFile{
    //从本地文件路径创建文件
    AVFile *file=[AVFile fileWithName:@"cloud.png" contentsAtPath:[[NSBundle mainBundle] pathForResource:@"cloud" ofType:@"png"]];
    //保存文件
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self log:[NSString stringWithFormat:@"文件已经保存到服务器:[%@] %@",file.objectId,file.url]];
        }else {
            [self log:[error description]];
        }
    }];
}

-(void)demoDeleteFile{
    //需要先得到一个AVFile, 可以是从Cloud数据中返回的, 这里直接创建了一个文件 然后删除它
    AVFile *file=[AVFile fileWithName:@"cloud.png" contentsAtPath:[[NSBundle mainBundle] pathForResource:@"cloud" ofType:@"png"]];
    [file save];
    
    //删除文件
    [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self log:[NSString stringWithFormat:@"文件[%@] 已经删除",file.objectId]];
        }else {
            [self log:[error description]];
        }
    }];
}

-(void)demoWithFileIdGetFile{
    NSString *fileId=@"5573fddee4b06a32094af62b";
    //第一步先得到文件实例, 其中会包含文件的地址
    [AVFile getFileWithObjectId:fileId withBlock:^(AVFile *file, NSError *error) {
        if ([self filterError:error]) {
            [self log:[NSString stringWithFormat:@"获取成功: %@",[file description]]];
            //文件实例获取成功可以再进一步获取文件内容
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(data){
                    //获取到了文件内容
                    //这儿我们已知它是个图片 所以可以显示图片
                    UIImage *img=[UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                    [self showImage:img];
                    [self log:[NSString stringWithFormat:@"成功得到图片: %@",[img description]]];
                }
            } progressBlock:^(NSInteger percentDone) {
                [self log:[NSString stringWithFormat:@"加载进度: %ld%%", (long)percentDone]];
            }];
        }
    }];
}

-(void)demoFileMetaData{
    // 可以用 metaData 来保存文件附属的信息，而不用新建表关联File表来做
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cloud" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.8);
    AVFile *file = [AVFile fileWithData:imageData];
    [file.metaData setObject:@(image.size.width) forKey:@"width"];
    [file.metaData setObject:@(image.size.height) forKey:@"height"];
    [file.metaData setObject:@"LeanCloud" forKey:@"author"];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self log:@"保存文件成功，同时关联了许多元数据 metaData : %@", file.metaData];
        }
    }];
}

- (void)demoFileClearCache{
    [AVFile clearAllCachedFiles];
    [self log:@"清除了全部文件的缓存，请运行用文件ID获取文件的例子，会看到下载进度多次被回调"];
}

MakeSourcePath
@end
