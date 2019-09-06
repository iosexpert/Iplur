//
//  ViewController.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *backgroundImage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    NSArray *animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"bg1.jpg"],[UIImage imageNamed:@"bg2.jpg"],[UIImage imageNamed:@"bg3.jpg"],[UIImage imageNamed:@"bg4.jpg"],[UIImage imageNamed:@"bg5.jpg"], nil];
    backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.animationImages=animationImages;
    [backgroundImage setAnimationDuration:6.0];
    backgroundImage.animationRepeatCount = 0;
    [self.view addSubview:backgroundImage];
    [backgroundImage startAnimating];
    
    
    
    UIImageView *logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 60, 200, 65)];
    logoimage.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:logoimage];
    
    
    
    UIFont * myFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    CGRect labelFrame = CGRectMake (20, 135, self.view.frame.size.width-40, 55);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=2;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    [label setText:@"Connect with like-minded people all over the world."];
    [self.view addSubview:label];
    
    UIButton *namelogin = [UIButton buttonWithType:UIButtonTypeCustom];
    namelogin.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    namelogin.layer.cornerRadius=3;
    [namelogin setTitle:@"Log In" forState:UIControlStateNormal];
    [namelogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    namelogin.frame = CGRectMake(30, self.view.frame.size.height/2-60, self.view.frame.size.width-60, 50);
    [self.view addSubview:namelogin];
    
    UIButton *fbLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLogin.layer.cornerRadius=3;
    [fbLogin setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [fbLogin addTarget:self action:@selector(FBLogin:) forControlEvents:UIControlEventTouchUpInside];
    fbLogin.backgroundColor=[UIColor colorWithRed:66/255.0 green:138/255.0 blue:186/255.0 alpha:1.0];
    fbLogin.frame = CGRectMake(30, self.view.frame.size.height/2, self.view.frame.size.width-60, 50);
    [self.view addSubview:fbLogin];
    
    UIButton *twiterLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [twiterLogin addTarget:self action:@selector(TWLogin:) forControlEvents:UIControlEventTouchUpInside];
    twiterLogin.layer.cornerRadius=3;
    [twiterLogin setTitle:@"Login with Twitter" forState:UIControlStateNormal];
    twiterLogin.backgroundColor=[UIColor colorWithRed:48/255.0 green:72/255.0 blue:118/255.0 alpha:1.0];
    twiterLogin.frame = CGRectMake(30, self.view.frame.size.height/2+60, self.view.frame.size.width-60, 50);
    [self.view addSubview:twiterLogin];
    
    UIButton *signUP = [UIButton buttonWithType:UIButtonTypeCustom];
    signUP.layer.cornerRadius=3;
    [signUP setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUP.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.25];
    [signUP addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    signUP.frame = CGRectMake(30, self.view.frame.size.height/2+120, self.view.frame.size.width-60, 50);
    [self.view addSubview:signUP];
    
    
    
    UILabel *fotterlabel = [[UILabel alloc] initWithFrame:CGRectMake (20, self.view.frame.size.height-75, self.view.frame.size.width-40, 55)];
    [fotterlabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    fotterlabel.lineBreakMode=NSLineBreakByWordWrapping;
    fotterlabel.numberOfLines=2;
    fotterlabel.textColor=[UIColor whiteColor];
    fotterlabel.textAlignment=NSTextAlignmentCenter;
    fotterlabel.backgroundColor=[UIColor clearColor];
    [fotterlabel setText:@"By signing in you are agree to our Privacy Policy and Terms of Services"];
    [self.view addSubview:fotterlabel];
    
    
    
}

- (IBAction)Login:(id)sender
{
    
}
- (IBAction)FBLogin:(id)sender
{
    
}
- (IBAction)TWLogin:(id)sender
{
    
}
- (IBAction)signup:(id)sender
{
    
}

@end
