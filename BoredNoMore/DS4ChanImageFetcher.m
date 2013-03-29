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

-(id) init
{
    self = [super init];
    if(self){
        _urls = [[NSMutableArray alloc] init];
        [self populateImageUrls:@"asp"];
        [self populateImageUrls:@"vr"]; //vr == retro games
        [self populateImageUrls:@"vr"];
        [self populateImageUrls:@"vr"];
        [self populateImageUrls:@"gd"];
        [self populateImageUrls:@"sci"];
    }
    return self;
}

-(void) populateImageUrls:(NSString *)board
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.4chan.org/%@/%d.json", board, arc4random()%10];
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
        }
        
    } failure:nil];
    
    [operation start];
}

-(void) updateImageViewWithNextImage:(UIImageView *)imageView andActivityIndicator:(UIActivityIndicatorView *)activityView
{
    NSUInteger objectIndex = arc4random() % [self.urls count];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.urls objectAtIndex:objectIndex]]];
    [self.urls removeObjectAtIndex:objectIndex];
    AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            [imageView setImage:image];
        });
    }];
    
    [activityView startAnimating];
    [op start];
}

@end
