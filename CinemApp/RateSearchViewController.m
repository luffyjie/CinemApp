#import "RateSearchViewController.h"

@interface RateSearchViewController ()

@end

#define getDataURL @"http://api.themoviedb.org/3/search/movie?include_adault=false&search_type=ngram&api_key=2da45d86a9897bdf7e7eab86aa0485e3&query="

@implementation RateSearchViewController{
    NSString *searchQuery;
}

@synthesize json, resultArray, mainTableView, moviesArray, activityIndicatorView, searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [searchBar setDelegate:self];
    [searchBar setShowsCancelButton:NO];
    [[self navigationItem] setTitleView:searchBar];
    searchBar.placeholder = @"Search";
    searchBar.tintColor = [UIColor colorWithRed:0.855 green:0.243 blue:0.251 alpha:1];
    
    [self.tableView setHidden:YES];
    [searchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    //Färg på navigationBaren
    UIImage *_defaultImage;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)refresh {
    [self.refreshControl endRefreshing];
}

//SÖK DELEGATE METHODS
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[self.searchBar becomeFirstResponder];
	[self.searchBar setShowsCancelButton:YES animated:YES];
    if([self.searchBar.text isEqualToString: @""]){
        moviesArray = nil;
        [self.tableView reloadData];
        [self.tableView setHidden:YES];
    }
    }
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    if([self.searchBar.text isEqualToString: @""]){
        moviesArray = nil;
        [self.tableView reloadData];
        [self.tableView setHidden:YES];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //int times = [[self.searchBar.text componentsSeparatedByString:@" "] count]-1;
    
    if ([self.searchBar.text length] > 2){
        searchQuery = self.searchBar.text;
        [self retrieveData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
    searchQuery = self.searchBar.text;
    [self retrieveData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

//TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return moviesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *movieTitle = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"];
    NSString *movieRelease = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];
    [cell.textLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Regular" size: 14.0]];
    if(![movieRelease isEqualToString:@""]){
        movieRelease = [NSString stringWithFormat:@"(%@)", [movieRelease substringToIndex:4]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", movieTitle, movieRelease];
        //cell.detailTextLabel.text = nil;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: cell.textLabel.attributedText];
        [text addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange([movieTitle length]+1, 6)];
        [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 13.0] range: NSMakeRange([movieTitle length]+1, 6)];
        
        [cell.textLabel setAttributedText: text];
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

//TABLE DELEGATE METHODS
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
    RateViewController * dvc = [[RateViewController alloc]init];
    
    //Retrieve the current selected movie
    dvc.movieID = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    dvc.movieName = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"original_title"];
    dvc.movieRelease = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"release_date"];
    dvc.movieBackground = [[moviesArray objectAtIndex:indexPath.row] valueForKey:@"backdrop_path"];
    dvc.moviePlot = [[moviesArray objectAtIndex:indexPath.row] objectForKey:@"overview"];

    NSLog(@"%@", [[moviesArray objectAtIndex:indexPath.row] objectForKey:@"original_title"]);
    NSLog(@"%@", [[moviesArray objectAtIndex:indexPath.row] objectForKey:@"overview"]);
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//HÄMTA DATA
- (void) retrieveData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *parsedSearchQuery;
        parsedSearchQuery = [searchQuery stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@", getDataURL, parsedSearchQuery]   stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfURL:url];
    
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
        moviesArray = [[NSMutableArray alloc] init];
        moviesArray = [json objectForKey:@"results"];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
            [self.tableView setHidden:NO];
        });
    });
        
}

@end
