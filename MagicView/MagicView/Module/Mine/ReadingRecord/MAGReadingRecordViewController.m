//
//  MAGReadRecordViewController.m
//  MagicView
//
//  Created by LL on 2021/10/21.
//

#import "MAGReadingRecordViewController.h"

#import "MAGReadingRecordViewController1.h"

@interface MAGReadingRecordViewController ()

@end

@implementation MAGReadingRecordViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MAGClickAgent appendDidAppearViewControllerName:@"阅读历史页面"];
    [MAGClickAgent event:@"用户进入阅读历史页面"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [MAGClickAgent event:@"用户离开阅读历史页面"];
}

+ (instancetype)readingRecordViewController {
    return [[MAGReadingRecordViewController1 alloc] init];
}

- (void)readBookWihtBookModel:(MAGBookModel *)bookModel {
    [self.navigationController pushViewController:[[MAGBookReaderViewController alloc] initWithBookID:bookModel.book_id] animated:YES];
    [MAGClickAgent event:@"用户点击了阅读历史的小说" attributes:@{@"book_id" : bookModel.book_id ?: @"NULL", @"book_name" : bookModel.name ?: @"NULL"}];
}


#pragma mark - Getter
- (NSArray<MAGBookModel *> *)bookReadingArray {
    return [MAGBookRecordManager.readingRecord copy];
}

@end
