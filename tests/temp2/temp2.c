#include <stdint.h>
#include "../include/gpio.h"

void delay(uint32_t);

int main()
{
    uint32_t seg_disp[10] = {0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f};
    uint32_t disp_num[4] = {0};
    uint32_t disp_sel = 1;
    uint32_t i, j;
    while(1)
    {
        for(i = 0; i < 50; ++i){
            GPIO_REG((GPIO_SEG_SEL)) = 1;
            GPIO_REG(GPIO_SEG) = seg_disp[disp_num[0]];
            delay(500000);
            GPIO_REG((GPIO_SEG_SEL)) = 2;
            GPIO_REG(GPIO_SEG) = seg_disp[disp_num[1]];
            delay(500000);
            GPIO_REG((GPIO_SEG_SEL)) = 4;
            GPIO_REG(GPIO_SEG) = seg_disp[disp_num[2]];
            delay(500000);
            GPIO_REG((GPIO_SEG_SEL)) = 8;
            GPIO_REG(GPIO_SEG) = seg_disp[disp_num[3]];
            delay(500000);
        }
        disp_num[0] += 1;
        if(disp_num[0] == 10){
            disp_num[0] = 0;
            disp_num[1] +=1;
        }
        if(disp_num[1] == 10){
            disp_num[1] = 0;
            disp_num[2] += 1;
        }
        if(disp_num[2] == 10){
            disp_num[2] = 0;
            disp_num[3] += 1;
        }
        if(disp_num[3] == 10){
            disp_num[3] = 0;
        }
    }
}

void delay(uint32_t num)
{
    int i = 0;
    for(i = 0; i < num; ++i);
    return;
}