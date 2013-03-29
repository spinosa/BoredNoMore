//
//  DS4ChanImageFetcher.m
//  BoredNoMore
//
//  Created by Daniel Spinosa on 3/29/13.
//  Copyright (c) 2013 Dan Spinosa. All rights reserved.
//

#import "DS4ChanImageFetcher.h"
#import "AFNetworking.h"

@interface DS4ChanImageFetcher()
@property (nonatomic, strong) NSMutableArray *urls;
@end

@implementation DS4ChanImageFetcher

#define API_URL_ARRAY @[@"http://api.4chan.org/asp/0.json", @"http://api.4chan.org/vr/0.json"]
#define BOARD_ARRAY @[@"asp", @"vr"]

-(id) init
{
    self = [super init];
    if(self){
        _urls = [[NSMutableArray alloc] init];
        [self populateImageUrls];
    }
    return self;
}

-(void) populateImageUrls
{
    NSString *board = BOARD_ARRAY[0];
    NSString *urlString = [NSString stringWithFormat:@"http://api.4chan.org/%@/0.json", board];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *req, NSHTTPURLResponse *response, id JSON) {
        
        // Flatten posts into a single array
        NSMutableArray *allPosts = [[NSMutableArray alloc] init];
        for (NSArray *posts in [JSON valueForKeyPath:@"threads.posts"]) {
            [allPosts addObjectsFromArray:posts];
        }
        
        // Grab the posts with images
        NSPredicate *filterForImages = [NSPredicate predicateWithFormat:@"tim != NULL AND ext != NULL"];
        NSArray *postsWithImages = [allPosts filteredArrayUsingPredicate:filterForImages];
        
        // Extract the URLs
        for(NSDictionary *dict in postsWithImages){
            NSString *imgUrl = [NSString stringWithFormat:@"http://images.4chan.org/%@/src/%@%@", board, dict[@"tim"], dict[@"ext"]];
            [_urls addObject:imgUrl];
            DLog(@"Storing image URL:  %@", imgUrl);
        }
        
    } failure:nil];
    
    [operation start];
}

/*
 
 pull this:
 http://api.4chan.org/pol/0.json

 look for response in this format:
 
 threads: [
    posts: [
        {tim: "XYZ", ext: ".jpg", ...},
        {tim: "ABC", ext: ".png", ...}
 
    ]
 ]
 
 Pull image XYZ like
 
 http://images.4chan.org/pol/src/1364569484220.jpg
 
 
 */


@end
