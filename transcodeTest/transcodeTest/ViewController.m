//
//  ViewController.m
//  transcodeTest
//
//  Created by tangzhixin on 2017/11/20.
//  Copyright © 2017年 tangzhixin. All rights reserved.
//

#import "ViewController.h"

//#import "transcode.h"

#import "./../../transcode/transcode/transcode.h"

@interface ViewController ()


@end


static double widgetHeight = 480;
static double widgetWidth = 360;


@implementation ViewController
{
    UIButton        *btnConnect;
    BOOL            bClick;
    
    dispatch_queue_t _graphTranscodeQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    bClick = NO;
    
    _graphTranscodeQueue = dispatch_queue_create("com.transcode.session.graph", 0);

    
    
    [self.view setFrame:CGRectMake(0, 0, widgetWidth, widgetHeight)];
    
    btnConnect = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 150, self.view.bounds.size.width -200, 50)];
    [btnConnect addTarget:self action:@selector(uiButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnConnect setTitle:@"noConnect" forState:UIControlStateNormal];
    
   [self.view setBackgroundColor:UIColor.blackColor];
    [self.view addSubview:btnConnect];
    
   
    
    //[_publisher.view addSubview:btnConnect];
}


-(BOOL) transcode
{
    NSString *transcode = @"ffmpeg -i ";
    
    NSString * inFile1 = [[self applicationDocumentsDirectory] stringByAppendingString:@"/in.mp4"];
    NSString * outFile1 = [[self applicationDocumentsDirectory] stringByAppendingString:@"/output.mp4"];
    
    //fmpeg -i MP4 -c copy -y Output.mp4
    //NSString *temp = @" -c:a copy -c:v libx264 -y ";
    NSString *temp = @" -c copy -y ";
    
    transcode = [NSString stringWithFormat:@"%@%@%@%@" , transcode, inFile1, temp, outFile1];
    
     [TransCodeSession console:transcode];
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)uiButtonTapped:(id)sender
{
    dispatch_sync(_graphTranscodeQueue, ^{
        for (int i = 0; i < 1; i ++) {
            NSLog(@"transcode begin\n");
           [self transcode];

            NSLog(@"transcode end i:%d\n", i);
        }
    });
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
