# radmap_preprocess
## Use
1. mkdir bagfiles/trial_name, cd bagfiles/trial_name
2. mv {port,starboard,imu}.bag
3. roslaunch radmap_preprocess lasers.launch
4. rosrun rosrun radmap_preprocess lasers 
5. python ../../src/bag_merge_radmap.py
6. TODO automation and temporary bag file deletion
## Dependencies
1. Velodyne 3D LIDARs ROS package
2. boost
