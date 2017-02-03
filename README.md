# Merging the bags
1. Place port.bag, starboard.bag, imu.bag into [insert folder]
2. cd [insert folder]
3. roslaunch radmap_preprocess lasers.launch 
4. rosrun  rosrun radmap_preprocess lasers 
5. python [insert path]/src/bag_merge_radmap.py

# Play the bags
1. roslaunch radmap_preprocess calibrated_tf.launch
2. rosbag play [insert bagfile]
3. rviz

# Run Cartographer
roslaunch cartographer_ros demo_radmap.launch bag_filename:=[insert bagfile path]

# Coordinate frame calibration (already completed)
1. velodyne_calib.m
2. fill in calibrated_tf.launch
3. roslaunch radmap_preprocess calibrated_tf.launch
4. rosrun tf tf_echo imu_link velodyne_port --> radmap.lau::velodyne_port_joint::origin
5. rosrun tf tf_echo imu_link velodyne_starboard --> radmap.lau::velodyne_starboard_joint::origin
