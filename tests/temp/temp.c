/*
 * Description  : 
 * Author       : Zhengyi Zhang
 * Date         : 2021-12-19 13:36:58
 * LastEditTime : 2021-12-20 11:28:38
 * LastEditors  : Zhengyi Zhang
 * FilePath     : \Buceros\tests\temp\temp.c
 */

int main()
{
    int* ram_ptr = (void*)0x20000000;
    int i, j, k;
    for(i = 2; i < 100; i++){
        k = 1;
        for(j = 2; j < i; j++){
            if(i % j == 0){
                k = 0;
                break;
            }
        }
        if(k == 1){
            *(ram_ptr++) = i;
        }
    }
}