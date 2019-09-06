//
//  commentViewController.m
//  naamee
//
//  Created by mac on 13/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "commentViewController.h"
#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "Helper.h"
@interface commentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    NSMutableArray *commentList;
    UILabel *postReaction;
    UIImageView *smileImage;
    UIView *likeBtnView;
    UIImage *postImage;
    UIBarButtonItem *menuBtn;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableDictionary *postDetails;
@property (strong, nonatomic) IBOutlet UITextField *commentField;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSString *titleText;
- (IBAction)postComment:(id)sender;
@end

@implementation commentViewController
@synthesize table, postDetails, bottomView, commentField, sendBtn, titleText;

- (void)viewDidLoad {
    [super viewDidLoad];
    postDetails = [[[NSUserDefaults standardUserDefaults]valueForKey:@"postDetails"]mutableCopy];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    navView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navView];
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    commentField = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 45)];
    commentField.delegate=self;
    commentField.placeholder=@"Add a commnet";
    [feildBackView addSubview:commentField];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    
    
    
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title=@"COMMENTS";
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title=[postDetails objectForKey:@"username"];
    
    if (titleText != nil){
        if ([titleText isEqualToString:@"TRENDING"] || [titleText isEqualToString:@"POPULAR"]){
            self.navigationItem.title=titleText;
        }
    }
    
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.tableHeaderView=[self tableHeaderView];
    
    if ([[postDetails objectForKey:@"user_id"] integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue])
    {
        menuBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menu)];
        self.navigationItem.rightBarButtonItem=menuBtn;
    }
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, commentField.frame.size.height)];
    commentField.leftView=leftView;
    commentField.leftViewMode=UITextFieldViewModeAlways;
    
    commentField.layer.cornerRadius=5;
    commentField.delegate=self;
    
    commentList=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePost:) name:@"DeletePost" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; //
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"likePostSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likePostSuccess:) name:@"likePostSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlikePostSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlikePostSuccess:) name:@"unlikePostSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addCommentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentSuccess:) name:@"addCommentSuccess" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([Helper isInternetConnected]==YES)
    {
       
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"getComments",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"         :[postDetails objectForKey:@"postid"]
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON: %@", json);
            [Helper hideIndicatorFromView:self.view];
            
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                self->commentList=[[json valueForKey:@"comments"] mutableCopy];
                [self->table reloadData];
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
        
       // [WebAPI getCommentsListForPost:[postDetails objectForKey:@"postid"]];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}



#pragma mark -- TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    NSDictionary *dic=[commentList objectAtIndex:indexPath.row];
    
    AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 8, 45, 45)];
    NSString *imageURL;
    if ([[dic objectForKey:@"pic"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"pic"] isEqualToString:@"<null>"])
    {
        
    }
    else
    {
        imageURL=  [NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"pic"]];
        
    }
    
    if (imageURL)
    {
        userImage.imageURL=[NSURL URLWithString:imageURL];
    }
    
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(userImage.frame.origin.x+userImage.frame.size.width+10, 8, self.view.frame.size.width-(userImage.frame.origin.x+userImage.frame.size.width+10+8), 20)];
    username.text=[dic objectForKey:@"name"];
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:15];
    
    UILabel *comment=[[UILabel alloc]initWithFrame:CGRectMake(username.frame.origin.x, username.frame.origin.y+username.frame.size.height, username.frame.size.width, 20)];
    comment.textColor=[UIColor darkGrayColor];
    comment.font=[UIFont fontWithName:Helvetica_REGULAR size:13];
    
    NSString *text=[dic objectForKey:@"comment"];
    
    comment.text=text;
    [comment sizeToFit];
    
    CGRect rect=[Helper calculateHeightForText:text fontName:Helvetica_REGULAR fontSize:13 maximumWidth:username.frame.size.width];
    
    CGRect frame=comment.frame;
    frame.origin.x=username.frame.origin.x;
    frame.origin.y=comment.frame.origin.y;
    frame.size.width=username.frame.size.width;
    frame.size.height=rect.size.height+8;
    comment.frame=frame;
    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(username.frame.origin.x, comment.frame.origin.y+comment.frame.size.height, username.frame.size.width, 20)];
    time.textColor=[UIColor lightGrayColor];
    //time.text=@"2 hour ago";
    time.font=[UIFont fontWithName:Helvetica_REGULAR size:13];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, time.frame.origin.y+time.frame.size.height, self.view.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [cell.contentView addSubview:userImage];
    [cell.contentView addSubview:username];
    [cell.contentView addSubview:comment];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:lineView];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    userImage.frame=CGRectMake(userImage.frame.origin.x, (lineView.frame.origin.y+lineView.frame.size.height)/2 - userImage.frame.size.height/2, userImage.frame.size.width, userImage.frame.size.height);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[commentList objectAtIndex:indexPath.row];
    NSString *text=[dic objectForKey:@"comment"];
    CGRect rect=[Helper calculateHeightForText:text fontName:Helvetica_REGULAR fontSize:13 maximumWidth:self.view.frame.size.width-(8+45+10+8)];
    return rect.size.height+8+20+20+1+8;
}

-(UIView *)tableHeaderView
{
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    AsyncImageView *imageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    CGFloat yCoordinate = imageView.frame.origin.y+imageView.frame.size.height+8;
    
    UILabel *caption=[[UILabel alloc]initWithFrame:CGRectMake(10, yCoordinate, self.view.frame.size.width-20, 20)];
    caption.textColor=[Helper colorFromHexString:@"343536"];
    caption.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    
    NSString *text=@"";
    if (![[postDetails objectForKey:@"caption"] isKindOfClass:[NSNull class]])
    {
        text=[postDetails objectForKey:@"caption"];
    }
    
    caption.text=text;
    
    CGRect rect=[Helper calculateHeightForText:text fontName:@"Helvetica Neue" fontSize:15 maximumWidth:self.view.frame.size.width-20];
    
    CGRect frame=caption.frame;
    frame.origin.x=10;
    frame.origin.y=caption.frame.origin.y;
    frame.size.width=self.view.frame.size.width-20;
    frame.size.height=rect.size.height+8;
    caption.frame=frame;
    
    yCoordinate = yCoordinate + caption.frame.size.height+8;
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, yCoordinate, self.view.frame.size.width, 0)];
    
    CGFloat viewHeight = 0;
    
    UIImageView *moodimage;
    UILabel *moodhashtag;
    
    if ([[postDetails objectForKey:@"mood"] length]>0)
    {
        moodimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        moodimage.image=[UIImage imageNamed:@"mood_share.png"];
        
        moodhashtag=[[UILabel alloc]initWithFrame:CGRectMake(moodimage.frame.origin.x+moodimage.frame.size.width+8, moodimage.frame.origin.y, self.view.frame.size.width-moodimage.frame.origin.x+moodimage.frame.size.width+8+8, 20)];
        moodhashtag.text=[postDetails objectForKey:@"mood"];
        moodhashtag.font=[UIFont systemFontOfSize:13];
        
        [detailView addSubview:moodimage];
        [detailView addSubview:moodhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *wearingimage;
    UILabel *wearinghashtag;
    if ([[postDetails objectForKey:@"wearing"] length]>0)
    {
        wearingimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        wearingimage.image=[UIImage imageNamed:@"wearing_share.png"];
        
        wearinghashtag=[[UILabel alloc]initWithFrame:CGRectMake(wearingimage.frame.origin.x+wearingimage.frame.size.width+8, wearingimage.frame.origin.y, self.view.frame.size.width-wearingimage.frame.origin.x+wearingimage.frame.size.width+8+8, 20)];
        wearinghashtag.text=[postDetails objectForKey:@"wearing"];
        wearinghashtag.font=[UIFont systemFontOfSize:13];
        
        [detailView addSubview:wearingimage];
        [detailView addSubview:wearinghashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *listeningimage;
    UILabel *listenhashtag;
    
    if ([[postDetails objectForKey:@"listening"] length]>0)
    {
        listeningimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        listeningimage.image=[UIImage imageNamed:@"listning_share.png"];
        
        listenhashtag=[[UILabel alloc]initWithFrame:CGRectMake(listeningimage.frame.origin.x+listeningimage.frame.size.width+8, listeningimage.frame.origin.y, self.view.frame.size.width-listeningimage.frame.origin.x+listeningimage.frame.size.width+8+8, 20)];
        listenhashtag.text=[postDetails objectForKey:@"listening"];
        listenhashtag.font=[UIFont systemFontOfSize:13];
        
        [detailView addSubview:listeningimage];
        [detailView addSubview:listenhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *watchimage;
    UILabel *watchhashtag;
    if ([[postDetails objectForKey:@"watching"] length]>0)
    {
        watchimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        watchimage.image=[UIImage imageNamed:@"watching_share.png"];
        
        watchhashtag=[[UILabel alloc]initWithFrame:CGRectMake(watchimage.frame.origin.x+watchimage.frame.size.width+8, watchimage.frame.origin.y, self.view.frame.size.width-watchimage.frame.origin.x+watchimage.frame.size.width+8+8, 20)];
        if ([[postDetails objectForKey:@"watching"] hasPrefix:@" "])
        {
            watchhashtag.text=[[postDetails objectForKey:@"watching"] substringFromIndex:1];
        }
        else
        {
            watchhashtag.text=[postDetails objectForKey:@"watching"];
        }
        watchhashtag.font=[UIFont systemFontOfSize:13];
        
        [detailView addSubview:watchimage];
        [detailView addSubview:watchhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *locationimage;
    UILabel *locationhashtag;
    
    if ([[postDetails objectForKey:@"location"] length]>0)
    {
        locationimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"where_share.png"];
        
        locationhashtag=[[UILabel alloc]initWithFrame:CGRectMake(locationimage.frame.origin.x+locationimage.frame.size.width+8, locationimage.frame.origin.y, self.view.frame.size.width-locationimage.frame.origin.x+locationimage.frame.size.width+8+8, 20)];
        locationhashtag.text=[postDetails objectForKey:@"location"];
        locationhashtag.font=[UIFont systemFontOfSize:13];
        
        [detailView addSubview:locationimage];
        [detailView addSubview:locationhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    viewHeight = viewHeight + 8;
    
    detailView.frame=CGRectMake(0, yCoordinate, self.view.frame.size.width, viewHeight);
    
    yCoordinate = yCoordinate + detailView.frame.size.height + 8;
    
    postReaction=[[UILabel alloc]initWithFrame:CGRectMake(10, yCoordinate, self.view.frame.size.width-20, 20)];
    
    NSString *smile = @"smile";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        smile = @"smiles";
    }
    
    NSString *comment = @"comment";
    if ([[postDetails objectForKey:@"totalComments"] integerValue]>1)
    {
        comment = @"comments";
    }
    
    NSString *repeat = @"repeat";
    if ([[postDetails objectForKey:@"totalShares"] integerValue]>1)
    {
        repeat = @"repeats";
    }
    postReaction.text=[NSString stringWithFormat:@"%@ %@    %@ %@    %@ %@", [postDetails objectForKey:@"totalLikes"], smile,  [postDetails objectForKey:@"totalComments"], comment, [postDetails objectForKey:@"totalShares"], repeat];
    postReaction.textColor=[UIColor lightGrayColor];
    postReaction.font=[UIFont fontWithName:Helvetica_REGULAR size:12];
    
    UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160/2, postReaction.frame.origin.y+postReaction.frame.size.height+15, 160, 35)];
    buttonView.backgroundColor=[UIColor whiteColor];
    
    likeBtnView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 7.5, 25, 25)];
    smileImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[postDetails objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor whiteColor]];
    }
    
    smileImage.contentMode=UIViewContentModeScaleAspectFill;
    smileImage.clipsToBounds=YES;
    [likeBtnView addSubview:smileImage];
    
    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    [likeBtn setBackgroundColor:[UIColor clearColor]];
    [likeBtn addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:likeBtnView];
    [buttonView addSubview:likeBtn];
    
    UIButton *commentBtn =[[UIButton alloc]initWithFrame:CGRectMake(70, 0, 35, buttonView.frame.size.height)];
    [commentBtn setImage:[UIImage imageNamed:@"comment_btn.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentPost:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *repeatBtn=[[UIButton alloc]initWithFrame:CGRectMake(115, 0, 35, buttonView.frame.size.height)];
    [repeatBtn setImage:[UIImage imageNamed:@"repeat_btn.png"] forState:UIControlStateNormal];
    [repeatBtn addTarget:self action:@selector(repeatPost:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:likeBtn];
    [buttonView addSubview:repeatBtn];
    [buttonView addSubview:commentBtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, buttonView.frame.origin.y+buttonView.frame.size.height+8, self.view.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [mainView addSubview:imageView];
    [mainView addSubview:caption];
    [mainView addSubview:detailView];
    [mainView addSubview:postReaction];
    [mainView addSubview:buttonView];
    [mainView addSubview:lineView];
    
    mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, lineView.frame.origin.y+lineView.frame.size.height);
    
    
    
    imageView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [postDetails objectForKey:@"postImage"]]];
    
    
    return mainView;
}
#pragma mark -- Button Action

-(void)likePost:(UIButton *)sender
{
    if ([Helper isInternetConnected]==YES)
    {
        if ([[postDetails objectForKey:@"islike"] integerValue]==0)
        {
            
            
            //like
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *params = @{
                                     @"method"       : @"likePost",
                                     @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                     @"postid"         :[postDetails objectForKey:@"postid"]
                                     };
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON: %@", json);
                [Helper hideIndicatorFromView:self.view];
                
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    
                }
                else
                {
                    [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
                }
                
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [Helper hideIndicatorFromView:self.view];
                
            }];
            
            
            
        }
        else
        {
            //dislike
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *params = @{
                                     @"method"       : @"likePost",
                                     @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                     @"postid"         :[postDetails objectForKey:@"postid"]
                                     };
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON: %@", json);
                [Helper hideIndicatorFromView:self.view];
                
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    
                }
                else
                {
                    [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
                }
                
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [Helper hideIndicatorFromView:self.view];
                
            }];
        }
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

-(void)commentPost:(UIButton *)sender
{
    [commentField becomeFirstResponder];
}

-(void)repeatPost:(UIButton *)sender
{
//    ShareToViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"share"];
//    controller.isReposting=YES;
//    controller.postDetails=postDetails;
//    controller.isCommenting=YES;
//    
//    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:controller];
//    [self.navigationController presentViewController:navController animated:YES completion:nil];
}
-(void)addCommentWithDetails:(NSDictionary *)details
{
    [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"addComments",
                             @"comment"      : [details valueForKey:@"comment"],
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"         :[details valueForKey:@"postid"]
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            long totalcomments=[[self->postDetails objectForKey:@"totalComments"] integerValue];
            totalcomments=totalcomments+1;
            [self->postDetails setObject:[NSString stringWithFormat:@"%lu", totalcomments] forKey:@"totalComments"];
            [self updateValues];
        }
        else
        {
            
            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
    
    
    

}
- (IBAction)postComment:(id)sender
{
    if (commentField.text.length>0)
    {
        if ([Helper isInternetConnected]==YES)
        {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:@"addComments" forKey:@"method"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"userid"];
            [dic setObject:[postDetails objectForKey:@"postid"] forKey:@"postid"];
            [dic setObject:commentField.text forKey:@"comment"];
            [self addCommentWithDetails:dic];
            
            NSMutableDictionary *commentDic=[NSMutableDictionary dictionary];
            [commentDic setObject:commentField.text forKey:@"comment"];
            
            NSString *dateStr=[Helper getDateStringFromDate:[NSDate date]];
            
            [commentDic setObject:dateStr forKey:@"createdon"];
            [commentDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] forKey:@"name"];
            [commentDic setObject:@"bg1.jpg" forKey:@"pic"];
            [commentList addObject:commentDic];
            
            [table reloadData];
            
            commentField.text=@"";
            [commentField resignFirstResponder];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
}

-(void)menu
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Share", @"Delete", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}

#pragma mark -- ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if (buttonIndex==0)
        {
            //edit
//            FiltersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"filter"];
//            controller.details=postDetails;
//            controller.capturedImage = postImage;
//            controller.isCommenting=YES;
//            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (buttonIndex==1)
        {
            //share
            NSArray *objectsToShare = @[postImage];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypePrint,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList];
            
            activityVC.excludedActivityTypes = excludeActivities;
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:activityVC animated:YES completion:nil];
            }
            //if iPad
            else {
                // Change Rect to position Popover
                activityVC.popoverPresentationController.sourceView = menuBtn;
            }
        }
        else if (buttonIndex==2)
        {
            //delete
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you really want to delete this post?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag=1;
            [alert show];
        }
    }
}

#pragma mark -- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [Helper showIndicatorWithText:@"Loading..." inView:self.view];
            [self deletePostByPostID:[postDetails objectForKey:@"postid"]];
        }
    }
}
-(void)deletePostByPostID:(NSString *)postID
{
    [Helper showIndicatorWithText:@"Deleting Post..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"deletePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"         :postID
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:self->postDetails];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
    
}
#pragma mark -- Helper Methods

-(void)updateValues
{
    NSString *smile = @"smile";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        smile = @"smiles";
    }
    
    NSString *comment = @"comment";
    if ([[postDetails objectForKey:@"totalComments"] integerValue]>1)
    {
        comment = @"comments";
    }
    
    NSString *repeat = @"repeat";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        repeat = @"repeats";
    }
    postReaction.text=[NSString stringWithFormat:@"%@ %@    %@ %@    %@ %@", [postDetails objectForKey:@"totalLikes"], smile,  [postDetails objectForKey:@"totalComments"], comment, [postDetails objectForKey:@"totalShares"], repeat];
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[postDetails objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor whiteColor]];
    }
}

#pragma mark -- Notification Methods

-(void)commentListSuccess:(NSNotification *)notification
{
    commentList=[notification.object mutableCopy];
    [table reloadData];
}

-(void)likePostSuccess:(NSNotification *)notification
{
    long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
    totalLikes=totalLikes+1;
    [postDetails setObject:@"1" forKey:@"islike"];
    [postDetails setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
    [self updateValues];
}

-(void)unlikePostSuccess:(NSNotification *)notification
{
    long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
    totalLikes=totalLikes-1;
    if (1>totalLikes)
    {
        totalLikes=0;
    }
    [postDetails setObject:@"0" forKey:@"islike"];
    [postDetails setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
    [self updateValues];
}

-(void)addCommentSuccess:(NSNotification *)notification
{
    long totalcomments=[[postDetails objectForKey:@"totalComments"] integerValue];
    totalcomments=totalcomments+1;
    [postDetails setObject:[NSString stringWithFormat:@"%lu", totalcomments] forKey:@"totalComments"];
    [self updateValues];
}

-(void)sharePostSuccess:(NSNotification *)notification
{
//    [[[[iToast makeText:@"Post shared successfully."]
//       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
}

-(void)deletePost:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:postDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark keyboard notifications methods

-(void) keyboardWillShow:(NSNotification *)note
{
    NSLog(@"keyboard Will Shown");
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [self moveControls:note up:YES];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSLog(@"keyboard Will Hide");
    
    [self moveControls:note up:NO];
}

- (void)moveControls:(NSNotification*)notification up:(BOOL)up
{
    NSDictionary* userInfo = [notification userInfo];
    CGRect newFrame = [self getNewControlsFrame:userInfo up:up];
    
    [self animateControls:userInfo withFrame:newFrame];
}

- (CGRect)getNewControlsFrame:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    CGRect newFrame = self.view.frame;
    
    if (up == YES)
    {
        newFrame.origin.y = -kbFrame.size.height+64;
    }
    else
    {
        newFrame.origin.y = 64;
    }
    
    return newFrame;
}

- (void)animateControls:(NSDictionary*)userInfo withFrame:(CGRect)newFrame
{
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

#pragma mark -- TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
