//
//  DatesAndTimes3Example.m
//  libxlsxwriter-ObjC
//
//  Created by Ludovico Rossi on 11/11/15.
//  Copyright © 2015 Ludovico Rossi. All rights reserved.
//

#import "xlsxwriter.h"
#import "DatesAndTimes3Example.h"

@implementation DatesAndTimes3Example

- (NSString *)title {
    return @"Dates and Times 3";
}

- (NSString *)subtitle {
    return @"Dates and times with different formats";
}

- (NSString *)outputFileName {
    return @"date_and_times03";
}

- (void)run {
    /*
     * Example of writing dates and times in Excel using different date formats.
     *
     * Copyright 2014-2015, John McNamara, jmcnamara@cpan.org
     *
     */
    
    /* A datetime to display. */
    lxw_datetime datetime = {2013, 1, 23, 12, 30, 5.123};
    uint32_t     row = 0;
    uint16_t     col = 0;
    int          i;
    
    /* Examples date and time formats. In the output file compare how changing
     * the format strings changes the appearance of the date.
     */
    char *date_formats[] = {
        "dd/mm/yy",
        "mm/dd/yy",
        "dd m yy",
        "d mm yy",
        "d mmm yy",
        "d mmmm yy",
        "d mmmm yyy",
        "d mmmm yyyy",
        "dd/mm/yy hh:mm",
        "dd/mm/yy hh:mm:ss",
        "dd/mm/yy hh:mm:ss.000",
        "hh:mm",
        "hh:mm:ss",
        "hh:mm:ss.000",
    };
    
    /* Create a new workbook and add a worksheet. */
    lxw_workbook  *workbook  = new_workbook([self.outputFilePath fileSystemRepresentation]);
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    /* Add a bold format. */
    lxw_format    *bold      = workbook_add_format(workbook);
    format_set_bold(bold);
    
    /* Write the column headers. */
    worksheet_write_string(worksheet, row, col,     "Formatted date", bold);
    worksheet_write_string(worksheet, row, col + 1, "Format",         bold);
    
    /* Widen the first column to make the text clearer. */
    worksheet_set_column(worksheet, 0, 1, 20, NULL);
    
    /* Write the same date and time using each of the above formats. */
    for (i = 0; i < 14; i++) {
        row++;
        
        /* Create a format for the date or time.*/
        lxw_format *format  = workbook_add_format(workbook);
        format_set_num_format(format, date_formats[i]);
        format_set_align(format, LXW_ALIGN_LEFT);
        
        /* Write the datetime with each format. */
        worksheet_write_datetime(worksheet, row, col, &datetime, format);
        
        /* Also write the format string for comparison. */
        worksheet_write_string(worksheet, row, col + 1, date_formats[i], NULL);
    }
    
    workbook_close(workbook);
}

@end
