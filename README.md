# radmap_preprocess
1. Place port.bag, starboard.bag, imu.bag
2. roslaunch radmap_preprocess lasers.launch 
3. rosrun  rosrun radmap_preprocess lasers 
4. python ../../src/bag_merge_radmap.py
5. TODO delete temporary bagfiles pc2_