import os
import time


def largest_image_num():
    all_files = os.listdir('.')
    jpgs = [jpg for jpg in all_files if jpg.endswith('.jpg')]
    nums = [int(n.partition('.jpg')[0]) for n in jpgs]
    return max(nums)

c = largest_image_num() + 1

while True:
    fname = 'scrot -q 95 %05d.jpg' % c
    print(fname)
    os.system(fname)
    c += 1
    time.sleep(2)
