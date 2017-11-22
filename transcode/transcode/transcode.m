//
//  transcode.m
//  transcode
//
//  Created by tangzhixin on 2017/11/18.
//  Copyright © 2017年 tangzhixin. All rights reserved.
//

#import "transcode.h"
#import "ffmpeg.h"

@implementation TransCodeSession

char** str_split(char* a_str, const char a_delim, int *retCount)
{
    char** result = 0;
    size_t count = 0;
    char* tmp = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;
    size_t idx  = 0;
    
    /* Count how many elements will be extracted. */
    int preDelim = 0;
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            if (!preDelim) {
                count++;
                preDelim = 1;
            }
            last_comma = tmp;
        } else {
            preDelim = 0;
        }
        tmp++;
    }
    
    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);
    
    /* Add space for terminating null string so caller
     knows where the list of returned strings ends. */
    
    result = malloc(sizeof(char*) * count);
    memset(result, 0, sizeof(char*) * count);
    
    if (result) {
        char* token = strtok(a_str, delim);
        
        while (token) {
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
    }
    
    *retCount = (int)count;
    
    NSLog(@"ffmpeg command params count = %d idx = %d", (int)count, (int)idx);
    
    return result;
}

+ (BOOL) console:(NSString*) inParam {
    BOOL bRet = NO;
    char **outParam;
    int count;
    char* agrv = (char*)[inParam UTF8String];
    
    outParam = str_split(agrv, ' ', &count);
    
    console(count, outParam);

    for (int i = 0; i < count; i ++) {
        free(*(outParam + i));
    }
    free(outParam);
    
    NSLog(@"ffmpeg end\n");
    
    return bRet;
}


@end
