//
//  DrinkPickerView.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/4/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "DrinkPickerView.h"
#import "Drink.h"

@implementation DrinkPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.7];
        // Initialization code
        UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 0, 300, 210)];
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        [myPickerView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];
        
        [self addSubview:myPickerView];
        self.pickerView = myPickerView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(viewTapped:)];
        [tap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)viewTapped:(UITapGestureRecognizer *)recognizer {
    [self removeFromSuperview];
//    [
}

- (NSString *)selectedDrinkType {
    NSString *drinkType = [[Drink types] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    return drinkType;
}


#pragma mark - UIPickerView Delegate
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[Drink types] count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [[Drink types] objectAtIndex:row];
    
    return title;
}



@end
