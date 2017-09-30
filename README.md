# JHLaunchAD
应用启动广告页

### use
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[JHTabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //在根控制器设置好之后 & After the rootViewController is set.
    [self xx_get_ad];
    
    return YES;
}

- (void)xx_get_ad
{
    [RequestManager getAD:nil success:^(id responseObject) {
        if (CODE == 1) {
            JHLaunchAD *launchAD = [[JHLaunchAD alloc] init];
            launchAD.delegate = self;
            [launchAD jh_show];
            launchAD.dic = responseObject[@"d"];
        }
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark - JHLaunchADDelegate
- (void)jh_launchAD:(UINavigationController *)nav clickAD:(NSDictionary *)dic{
    WebLinkController *web = [[WebLinkController alloc] init];
    web.url = dic[@"url"];
    web.navTitle = dic[@"title"];
    [nav pushViewController:web animated:YES];
}

```

