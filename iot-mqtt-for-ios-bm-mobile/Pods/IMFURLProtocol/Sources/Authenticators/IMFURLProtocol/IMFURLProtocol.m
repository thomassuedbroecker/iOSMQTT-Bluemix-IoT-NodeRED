/*
 * IBM Confidential OCO Source Materials
 *
 * Copyright IBM Corp. 2006, 2013
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *
 */

#import "IMFURLProtocol.h"

@interface IMFURLProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property NSURLResponse *currentResponse;

- (BOOL) sendRequestToProtectedResource;
- (BOOL) isOAuthError;
@end

@implementation IMFURLProtocol

@synthesize currentResponse, oauthResources;

+(IMFURLProtocol *) sharedInstance {
    static IMFURLProtocol *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        [self setOauthResources:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void) registerProtectedResourceWithPath:(NSString *)resourceURL {
    for (NSString *path in  oauthResources) {
        if ([path isEqualToString:resourceURL]) {
            return;
        }
    }
    [oauthResources addObject:resourceURL];
}

- (BOOL) shouldHandleResource:(NSString *)resourcePath {
    for (NSString *path in oauthResources) {
        if ([resourcePath rangeOfString:path].length > 0) {
            return YES;
        }
    }
    return NO;
}

- (void) unregisterProtectedResourceWithPath:(NSString *)resourceURL {
    NSUInteger i = 0;
    for (NSString *path in oauthResources) {
        if ([path isEqualToString:resourceURL]) {
            [oauthResources removeObjectAtIndex:i];
            return;
        }
        i++;
    }
}

- (void) registerIMFURLProtocol {
    [NSURLProtocol registerClass:[IMFURLProtocol class]];
}

#pragma mark -
#pragma mark NSURLProtocol methods
+ (BOOL)canInitWithRequest:(NSURLRequest *)request; {
    BOOL hasToken = [[request valueForHTTPHeaderField:@"Authorization"] rangeOfString:@"Bearer"].length > 0;
    
    return !hasToken && [[IMFURLProtocol sharedInstance] shouldHandleResource:[request URL].absoluteString];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    if (![self sendRequestToProtectedResource]) {
        [[IMFAuthorizationManager sharedInstance] obtainAuthorizationHeaderWithCompletionHandler: ^(IMFResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Failed to get access token. Error: %@", [error localizedDescription]);
            } else {
                [self sendRequestToProtectedResource];
            }
        }];
    }
}

- (BOOL) sendRequestToProtectedResource {
    NSString *cachedAccessToken = [[IMFAuthorizationManager sharedInstance] cachedAuthorizationHeader];
    if (cachedAccessToken) {
        NSMutableURLRequest *newRequest = [self.request mutableCopy];
        [newRequest setValue:cachedAccessToken forHTTPHeaderField:@"Authorization"];
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
        return YES;
    }
    
    return NO;
}

- (void)stopLoading {
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self setCurrentResponse:response];
    if ([self isOAuthError]) {
        [[IMFAuthorizationManager sharedInstance] obtainAuthorizationHeaderWithCompletionHandler:^(IMFResponse* imfResponse, NSError *error) {
            if (error) {
                 NSLog(@"Failed to get access token. Error: %@", [error localizedDescription]);
            } else {
                [self sendRequestToProtectedResource];
            }
        }];
    } else {
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }
    
}

-(BOOL) isOAuthError {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)currentResponse;
    int status = (int)[httpResponse statusCode];
    NSString *wwwAuthenticateHeaderValue = [[httpResponse allHeaderFields] valueForKey:@"WWW-Authenticate"];
    return (status == 401 || status == 403) && [wwwAuthenticateHeaderValue rangeOfString:@"Bearer"].length > 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (![self isOAuthError]) {
        [self.client URLProtocol:self didLoadData:data];
        NSLog(@"URL connection data has been received");
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (![self isOAuthError]) {
        [self.client URLProtocolDidFinishLoading:self];
        NSLog(@"URL connection finished loading");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (![self isOAuthError]) {
        [self.client URLProtocol:self didFailWithError:error];
        NSLog(@"URL connection failed with error: %@", [error localizedDescription]);
    }
}

#define IMF_URL_PROTOCOL_VERSION    @"1.1"
/**
 * Returns the current IMFURLProtocol version
 */
+(NSString*) version {
    return IMF_URL_PROTOCOL_VERSION;
}
@end