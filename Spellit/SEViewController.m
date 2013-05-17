//
//  SEViewController.m
//  Spellit
//
//  Created by Sergio Estevao on 26/08/2012.
//  Copyright (c) 2012 Sergio Estevao. All rights reserved.
//

#import "SEViewController.h"

@interface SEViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@property (retain, nonatomic) NSDictionary *phoneticsData;
@property (retain, nonatomic) NSArray *indexData;

@end

@implementation SEViewController
@synthesize table;
@synthesize search;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.phoneticsData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"phonetics" ofType:@"plist"] ];
    self.indexData = [[self.phoneticsData allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES]]];
    [self.table reloadData];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setSearch:nil];
    self.phoneticsData = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//
// numberOfSectionsInTableView:
//
// Parameters:
//    tableView - should be the table we control
//
// returns 1 (we have only one section)
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Parameters:
//    tableView - should be the table we control
//    section - a section in the table
//
// returns the number of rows in the section as specified by loaded plist
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.indexData count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Constructs/configures the view for a given row of data
//
// Parameters:
//    tableView - should be the table we control
//    indexPath - the indexPath of the row whose view we will construct/configure
//
// returns the constructed/configured row
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	
	// Configure the cell.
	cell.textLabel.text = [self.indexData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text= [self.phoneticsData objectForKey:cell.textLabel.text];
	
	return cell;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString * upperText = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if (upperText.length == 0){
        self.indexData = [[self.phoneticsData allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES]]];
        [self.table reloadData];
        return;
    }

    NSMutableArray * result = [NSMutableArray array];
    for(int i = 0; i < upperText.length; i++){
        [result addObject:[upperText substringWithRange:NSMakeRange(i, 1)]];
    }
        
    self.indexData = result;
    [self.table reloadData];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
 
@end
