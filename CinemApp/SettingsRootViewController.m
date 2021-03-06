
//
//  SettingsViewController.m
//  CinemApp
//
//  Created by Teodor Östlund on 2014-02-20.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "SettingsRootViewController.h"
#import "NotLoggedInViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"

@interface SettingsRootViewController ()

@end

@implementation SettingsRootViewController

@synthesize accountSection, generalSection, aboutSection, profileSettingsView, securitySettingsView, notificationsSettingsView, tabController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Settings"];
	
	self.accountSection = @[@"Profile settings", @"Security settings", @"Push notifications"];
    
    self.aboutSection = @[@"FAQ", @"About us", @"Terms of service"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	//self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //Sätter knapparna i navigationBar till röda
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1]];
    
    //Färg på navigationBaren
    UIImage *_defaultImage;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return @"USER SETTINGS";
    case 1:
        return @"INFORMATION";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0)
        return self.accountSection.count;
    else if(section==1)
        return self.aboutSection.count;
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
    if(indexPath.section == 0){
        cell.textLabel.text = self.accountSection[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 1){
        cell.userInteractionEnabled = NO;
        cell.textLabel.text = self.aboutSection[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.textLabel.text = @"Log out";
        cell.textLabel.textColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            profileSettingsView = [[ProfileSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:profileSettingsView animated:YES];
        }
        else if(indexPath.row==1)
        {
            securitySettingsView = [[SecuritySettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:securitySettingsView animated:YES];
        }
        else if(indexPath.row==2)
        {
            notificationsSettingsView = [[PushNotificationsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:notificationsSettingsView animated:YES];
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            //Och så vidare...
        }
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log out"
                                                            message:@"Are you sure you want to logout?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
            
            [alert show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [PFUser logOut];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NotLoggedInViewController *loginView = [[NotLoggedInViewController alloc] init];
        UINavigationController *logInNav = [[UINavigationController alloc] initWithRootViewController:loginView];
        logInNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [app.window.rootViewController presentViewController:logInNav animated:NO completion:nil];
        
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:NO];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Användaren utloggad");
    }
    else if (buttonIndex == 0) {
        // this is cancel button
    }
}

@end
