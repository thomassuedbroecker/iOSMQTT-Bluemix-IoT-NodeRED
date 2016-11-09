/*
 * Licensed Materials - Property of IBM
 * (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>
#import <IMFCore/IMFCore.h>

@interface IMFURLProtocol : NSURLProtocol

/**
 *  <#Description#>
 */
@property NSMutableArray * oauthResources;

/**
 *  Shared Instance of IMFNSURLProtocol
 *
 *  @return Shared Instance of IMFURLProtocol
 */
+ (IMFURLProtocol *) sharedInstance;

/**
 *  Call this method to let the SDK manage the authentication flow when using NSURLRequest.
 *  By calling registerIMFURLProtocol the SDK will intercept any request which is registered with registerProtectedResourceWithPath method
 */
- (void) registerIMFURLProtocol;

/**
 *  Add url path to be intercepted by the SDK
 *
 *  @param resourceURL The resource url to be intercepted
 */
- (void) registerProtectedResourceWithPath:(NSString *)resourceURL;

/**
 *  Remove url path from being intercepted by the SDK
 *
 *  @param resourceURL The resource url to be removed
 */
- (void) unregisterProtectedResourceWithPath:(NSString *)resourceURL;

- (BOOL) shouldHandleResource:(NSString *)resourcePath;

/**
 * Returns the current IMFURLProtocol version
 */
+(NSString*) version;

@end


