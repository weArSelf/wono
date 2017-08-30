//
//  HDQiNiuOperation.m
//  New Orient2
//
//  Created by Chris on 15-1-9.
//
//

#import "HDQiNiuOperation.h"


@implementation HDQiNiuOperation

+ (QNOperation *)defaultOperation
{
    static QNOperation *operation;
    
    @synchronized(self)
    {
        if (!operation)
        {
            operation = [[QNOperation alloc] init];
        }        
        return operation;
    }
}

@end
