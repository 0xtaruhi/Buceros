/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-18 10:54:07
 * LastEditTime : 2021-12-21 20:11:04
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\include\gpio.h
 */
#ifndef _GPIO_H_
#define _GPIO_H_

#define GPIO_RW_BASE            (0x40000000)
#define GPIO_LED                (GPIO_RW_BASE + (0x00))
#define GPIO_SEG                (GPIO_RW_BASE + (0x04))
#define GPIO_SEG_SEL            (GPIO_RW_BASE + (0x08))
#define GPIO_RO_BASE            (0x50000000)
#define GPIO_SW                 (GPIO_RO_BASE + (0x04))

#define GPIO_REG(addr)          (*((volatile uint32_t *)addr))

#define SEG_NUM_0   

#endif