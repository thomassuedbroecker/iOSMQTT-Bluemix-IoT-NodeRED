/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  ProfilesTableViewController.m
//  IoTstarter
//

#import "ProfilesTableViewController.h"
#import "AppDelegate.h"

@interface ProfilesTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ProfilesTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.profileTableController= self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = PROFILES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.backButton.layer.cornerRadius = 10;
    self.saveButton.layer.cornerRadius = 10;
}

- (IBAction)backPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Profile" message:@"Enter a name for the profile" delegate:self cancelButtonTitle:CANCEL_STRING otherButtonTitles:OK_STRING, nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // cancel pressed
        return;
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    IoTProfile *profile = [[IoTProfile alloc] initWithName:[alertView textFieldAtIndex:0].text organization:self.currentOrganization deviceID:self.currentDeviceID authorizationToken:self.currentAuthToken];
    
    IoTProfile *existingProfile;
    NSInteger profileCount = appDelegate.profiles.count;
    int index = 0;
    for (index=0; index < profileCount; index++)
    {
        existingProfile = [appDelegate.profiles objectAtIndex:index];
        if ([existingProfile.profileName isEqualToString:profile.profileName])
        {
            // Found profile with the same name. Overwrite it.
            [appDelegate.profiles removeObject:existingProfile];
            break;
        }
    }
    [appDelegate.profiles addObject:profile];
    [self reloadData];
    
    [appDelegate storePropertiesToArchive];
}

/*************************************************************************
 * UITableView delegate methods
 *************************************************************************/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // The table will always have only 1 section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.profiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileTableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [[appDelegate.profiles objectAtIndex:indexPath.row] profileName];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [[UIColor alloc] initWithRed:78/255.0 green:79/255.0 blue:80/255.0 alpha:1.0];
    
    NSString *currentProfileName = [appDelegate.currentProfile profileName];
    NSString *thisProfileName = [[appDelegate.profiles objectAtIndex:indexPath.row] profileName];
    if ([currentProfileName isEqualToString:thisProfileName])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    IoTProfile *profile = [appDelegate.profiles objectAtIndex:indexPath.row];
    appDelegate.deviceID = profile.deviceID;
    appDelegate.organization = profile.organization;
    appDelegate.authToken = profile.authorizationToken;
    appDelegate.currentProfile = profile;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    dispatch_async(dispatch_get_main_queue(), ^{        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        IoTProfile *profile = [appDelegate.profiles objectAtIndex:indexPath.row];
        [appDelegate.profiles removeObject:profile];
        [self.tableView reloadData];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
