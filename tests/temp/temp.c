/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-19 13:36:58
 * LastEditTime : 2021-12-21 22:20:27
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\temp\temp.c
 */

#include <stdint.h>
#include "../include/gpio.h"

int main()
{
    volatile uint32_t led_data = 0x1;
    while(1){
        led_data += 1;
        if(led_data == 0xffff){
            led_data = 0x0;
        }
        GPIO_REG(GPIO_LED) = led_data;
        for(volatile uint32_t i = 0; i != 500000; ++i);
    }
}