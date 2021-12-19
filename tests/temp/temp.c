/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-18 10:52:23
 * LastEditTime : 2021-12-19 01:27:52
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\temp\temp.c
 */
#include <stdint.h>

int main()
{
    int i, k;
    int* ptr = (void*)0x20000000;
    // for(i = 2; i < 10; i++){
    //     int p = 1;
    //     for(k = 2; k < i / 2 + 1; k++){
    //         if(i % k == 0){
    //             p = 0;
    //             break;
    //         }
    //     }
    //     if(p == 1){
    //         *ptr = i;
    //         ptr++;
    //     }
    // }
    for(i = 1; i < 100; i++){
        k += i;
    }
    *ptr = k;
}