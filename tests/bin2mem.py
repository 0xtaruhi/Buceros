import sys
import os

fileloc = os.path.join(os.getcwd(), sys.argv[1])

desfileloc = fileloc.replace('bin', 'mem')

fp = open(fileloc, 'rb')
des_fp = open(desfileloc, 'w')
size = os.path.getsize(fileloc)
for i in range((int)(size/4)):
    word_info = [0,0,0,0]
    for j in range(4):
        data_temp = fp.read(1)
        word_info[3-j] = ''.join('%02X' %x for x in data_temp)
    des_fp.write(''.join(word_info))
    des_fp.write('\n')

fp.close()
des_fp.close()