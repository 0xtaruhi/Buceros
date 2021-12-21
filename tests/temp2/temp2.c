/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-22 00:38:56
 * LastEditTime : 2021-12-22 01:09:12
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\temp2\temp2.c
 */

#include <stdint.h>

int main()
{
    int i, j, sum;
    int* ptr = (int*)0x20000000;
    for(i=1; i<1000; i++){
        sum = 0;
        for(j = 1; j < i; j++){
            if( i % j == 0 ){
                sum += j;
            }
        }
        if(sum == i){
            *(ptr++) = i;
        }
    }
}