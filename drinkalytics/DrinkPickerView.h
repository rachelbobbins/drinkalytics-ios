//
//  DrinkPickerView.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/4/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinkPickerView : UIView <UIPickerViewDelegate>
@property UIPickerView *pickerView;
- (NSString *)selectedDrinkType;
@end
