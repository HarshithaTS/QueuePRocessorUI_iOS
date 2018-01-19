//
//  LogViewController.m
//  GenericQueueProcessor
//
//  Created by Harshitha on 11/23/15.
//  Copyright (c) 2015 GSS Software. All rights reserved.
//

#import "LogViewController.h"
#import "LogTextViewController.h"
#import "GQPViewController.h"
#import "GSPKeychainStoreManager.h"

@interface LogViewController ()

@property (strong, nonatomic) IBOutlet UITableView *logTable;
@property (strong, nonatomic) NSArray *logFilesArray;
@property(strong ,nonatomic)NSMutableArray *sortedDateArray;
@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.logFilesArray = [[NSMutableArray alloc]init];
        self.sortedDateArray =[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Logs";
    self.navigationItem.hidesBackButton = YES;

    [[QPLogs sharedInstance] addSwipeGestureRecognizerForTarget:self withSelctor:@selector(loadQPView:) forDirection:UISwipeGestureRecognizerDirectionRight];
    
    
    
    self.logFilesArray = [[QPLogs sharedInstance]fetchLogFileNames:@"QueueProcessorLogs"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.logTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logFilesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    cell.textLabel.textColor = [UIColor colorWithRed:67.0/255 green:97.0/255 blue:40/255 alpha:1.0];
    NSLog(@"Log files array %@",self.logFilesArray);
    NSMutableArray *trimmedArray =[[NSMutableArray alloc]init];
   // NSMutableArray *sortedDateArray = [[NSMutableArray alloc]init];
    for(int i=0;i<[self.logFilesArray count];i++){
        NSString *trimmedstring =@"";
        NSRange range=[[self.logFilesArray objectAtIndex:i]rangeOfString:@"Log "];
        trimmedstring = [[self.logFilesArray objectAtIndex:i]substringFromIndex:NSMaxRange(range)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd,yyyy"];
        NSDate *orignalDate   =  [dateFormatter dateFromString:trimmedstring];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *finalString = [dateFormatter stringFromDate:orignalDate];
        NSLog(@"Formatted date %@",finalString);
        [trimmedArray addObject:finalString];
    }
    NSLog(@"The trimmed array is %@",trimmedArray);
    [trimmedArray sortUsingSelector:@selector(compare:)];
    NSLog(@"The trimmed date array %@",trimmedArray);
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[trimmedArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"the date array %@",reverseOrder);
    for(int i=0;i<[reverseOrder count];i++){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *originalDate = [dateFormatter dateFromString:[reverseOrder objectAtIndex:i]];
        [dateFormatter setDateFormat:@"MMM dd,yyyy"];
        NSString *finalString = [dateFormatter stringFromDate:originalDate];
        NSString *finalString1 = [NSString stringWithFormat:@"Log %@",finalString];
        [_sortedDateArray addObject:finalString1];
        
    }
    NSLog(@"the sorted date array %@",_sortedDateArray);
    cell.textLabel.text = [self.sortedDateArray objectAtIndex:indexPath.row];
    if (IS_IPHONE)
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *sharedFolderPAth =  [[[QPLogs sharedInstance]getSharedContainerURLPath]path];
    
    NSString *directory = [sharedFolderPAth stringByAppendingPathComponent:@"QueueProcessorLogs"];
    
     NSString *logText = [[QPLogs sharedInstance]readStringFromLogFile:[self.sortedDateArray objectAtIndex:indexPath.row] fromDirectory:directory];
    
    LogTextViewController *logTextView;
    
    if (IS_IPAD)
        logTextView = [[LogTextViewController alloc]initWithNibName:@"LogTextViewController" bundle:nil forLogFile:[self.sortedDateArray objectAtIndex:indexPath.row] withLogText:logText];
    else
        logTextView = [[LogTextViewController alloc]initWithNibName:@"LogTextViewController_iPhone" bundle:nil forLogFile:[self.sortedDateArray objectAtIndex:indexPath.row] withLogText:logText];
    
    [self.navigationController pushViewController:logTextView animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        cell.backgroundColor =  [UIColor colorWithRed:167.0/255 green:193.0/255 blue:160.0/255 alpha:1.0];
    }
}

- (void) loadQPView:(id)sender
{
//    GQPViewController *QPView = [[GQPViewController alloc]initWithNibName:@"GQPViewController_iPad" bundle:nil];
//    [self.navigationController pushViewController:QPView animated:YES];
//    [self.navigationController popToViewController:QPView animated:YES];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
   
}

@end
