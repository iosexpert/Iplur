//
//  tabbarViewController.m
//  MYScores
//
//  Created by Apple on 05/09/16.
//  Copyright © 2016 SuperSports. All rights reserved.
//

#import "tabbarViewController.h"
#import "landingViewController.h"
#import "profileViewController.h"
#import "productViewController.h"

@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.viewControllers = [self initializeViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSArray *) initializeViewControllers
{
    
    productViewController *smvc = [[productViewController alloc]init];
    landingViewController *smvc1 = [[landingViewController alloc]init];
    profileViewController *smvc2 = [[profileViewController alloc]init];


    UIImage *img = [[UIImage imageNamed:@"product"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *imgSelected = [[UIImage imageNamed:@"productSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img1 = [[UIImage imageNamed:@"camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected1 = [[UIImage imageNamed:@"cameraSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img2 = [[UIImage imageNamed:@"user"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected2 = [[UIImage imageNamed:@"userSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    //UIImage* tabBarBackground = [UIImage imageNamed:@"FullContact"];
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = true;
    smvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img selectedImage:imgSelected];
    smvc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img1 selectedImage:imgSelected1];
    smvc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img2 selectedImage:imgSelected2];

    smvc.navigationController.navigationBarHidden=true;
    smvc1.navigationController.navigationBarHidden=true;
    smvc2.navigationController.navigationBarHidden=true;

    smvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    smvc1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    smvc2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:smvc];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:smvc1];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:smvc2];

    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:nav1];
    [tabViewControllers addObject:nav2];
    [tabViewControllers addObject:nav3];

    return tabViewControllers;
   
}


@end
