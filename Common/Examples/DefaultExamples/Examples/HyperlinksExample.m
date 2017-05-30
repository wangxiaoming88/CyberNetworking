//
//  HyperlinksExample.m
//  libxlsxwriter-ObjC
//
//  Created by Ludovico Rossi on 11/11/15.
//  Copyright © 2015 Ludovico Rossi. All rights reserved.
//

#import <libxlsxwriter/xlsxwriter.h>
#import "HyperlinksExample.h"

@implementation HyperlinksExample

- (NSString *)title {
    return @"Hyperlinks";
}

- (NSString *)subtitle {
    return @"A example of writing urls/hyperlinks";
}

- (NSString *)outputFileName {
    return @"hyperlinks";
}

- (void)run {
    /*
     * Example of writing urls/hyperlinks with the libxlsxwriter library.
     *
     * Copyright 2014-2015, John McNamara, jmcnamara@cpan.org
     *
     */
    
    /* Create a new workbook. */
    lxw_workbook *workbook   = new_workbook([self.outputFilePath fileSystemRepresentation]);
    
    /* Add a worksheet. */
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    /* Add some cell formats for the hyperlinks. */
    lxw_format *url_format   = workbook_add_format(workbook);
    lxw_format *red_format   = workbook_add_format(workbook);
    
    /* Create the standard url link format. */
    format_set_underline (url_format, LXW_UNDERLINE_SINGLE);
    format_set_font_color(url_format, LXW_COLOR_BLUE);
    
    /* Create another sample format. */
    format_set_underline (red_format, LXW_UNDERLINE_SINGLE);
    format_set_font_color(red_format, LXW_COLOR_RED);
    
    /* Widen the first column to make the text clearer. */
    worksheet_set_column(worksheet, 0, 0, 30, NULL);
    
    /* Write a hyperlink. */
    worksheet_write_url(worksheet,    0, 0, "http://libxlsxwriter.github.io", url_format);
    
    /* Write a hyperlink but overwrite the displayed string. */
    worksheet_write_url   (worksheet, 2, 0, "http://libxlsxwriter.github.io", url_format);
    worksheet_write_string(worksheet, 2, 0, "Read the documentation.",        url_format);
    
    /* Write a hyperlink with a different format. */
    worksheet_write_url(worksheet,    4, 0, "http://libxlsxwriter.github.io", red_format);
    
    /* Write a mail hyperlink. */
    worksheet_write_url   (worksheet, 6, 0, "mailto:jmcnamara@cpan.org",      url_format);
    
    /* Write a mail hyperlink and overwrite the displayed string. */
    worksheet_write_url   (worksheet, 8, 0, "mailto:jmcnamara@cpan.org",      url_format);
    worksheet_write_string(worksheet, 8, 0, "Drop me a line.",                url_format);
    
    /* Close the workbook, save the file and free any memory. */
    workbook_close(workbook);
}

@end
