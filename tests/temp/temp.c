<<<<<<< HEAD
=======
/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-19 13:36:58
 * LastEditTime : 2021-12-21 21:12:59
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\temp\temp.c
 */
>>>>>>> 6d314306bac20b1dde76b1494b42741f53f2d67d

#include <stdint.h>
#include "../include/gpio.h"

int main()
{
<<<<<<< HEAD
    int i, sum;
    sum = 0;
    for(i = 0; i <= 100; ++i){
        sum += i;
=======
    volatile uint32_t led_data = 0x1;
    while(1){
        led_data *= 2;
        if(led_data == 0x10000){
            led_data = 0x1;
        }
        GPIO_REG(GPIO_LED) = led_data;
        for(volatile uint32_t i = 0; i != 500000; ++i);
>>>>>>> 6d314306bac20b1dde76b1494b42741f53f2d67d
    }
}