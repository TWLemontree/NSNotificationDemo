//
//  ViewController.m
//  通知
//
//  Created by 抬头看见柠檬树 on 2017/2/13.
//  Copyright © 2017年 csip. All rights reserved.
//


/*
    该VC演示的是通知的基本用法，而下面的GCDViewController演示的是通知与多线程的联合使用
*/

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) NSObject *observer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 通知顺序：先监听，再发送
    
    // 监听通知
    // Observe：观察者
    // selector：只要一监听到通知，就会调用观察者这个方法
    // Name：通知名称
    // object：是谁发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNote:) name:@"note" object:nil];
    
    // queue：The operation queue to which block should be added.
    //  If you pass nil, the block is run synchronously on the posting thread.
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"note" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"接收到通知");
    }];
    
    // 发出通知
    // Name：通知名称
    // object：谁发出的通知
    // userInfo：要传的参数
    [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
}

// 一个对象即将销毁就会调用
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}

// 监听到通知就会调用
- (void)reciveNote:(NSNotification *)notification
{
    // notification.userInfo是发送通知时传的参数
    NSLog(@"接收到通知");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end



































