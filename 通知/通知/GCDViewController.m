//
//  GCDViewController.m
//  通知
//
//  Created by 抬头看见柠檬树 on 2017/2/13.
//  Copyright © 2017年 csip. All rights reserved.
//

/*
    使用该VC记得在storyboard中修改ViewController绑定的VC
 */

#import "GCDViewController.h"

@interface GCDViewController ()

@property (nonatomic, weak) NSObject *observer;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
        首先是- addObserver:selector:name:object:方法接收通知时的情况
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 由于通知是在异步线程接收的，因此无法保证 接收通知在发送通知之前
        // 将发送通知代码写在-touchesBegan:withEvent 方法中，当用户点击屏幕后再发送通知，即可解决顺序问题
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNote:) name:@"note" object:nil];
    });
    
    
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"note" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 通过该方法接收通知，逻辑处理代码所在线程与queue:参数有关。
        // 使用该方法的好处在于，可以自己控制逻辑代码所在线程
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 需要注意的是，如果只需要添加一次通知的话，需要定义一个bool进行下处理，否则每次点击屏幕，都会发送下通知。
    [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
}

- (void)receiveNote:(NSNotification *)note
{
    /*
        通过 - addObserver:selector:name:object:方法接收通知，接收通知逻辑代码的线程由发送通知的方法所处的线程决定。如果-postNotificationName:object:方法在主线程中，则逻辑处理方法也在主线程；反之，如果-postNotificationName:object:方法在异步线程，那么逻辑处理代码也在异步线程。与接收通知代码所在线程无关。
     */
    NSLog(@"%@",[NSThread currentThread]);
}

// 一个对象即将销毁就会调用
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
