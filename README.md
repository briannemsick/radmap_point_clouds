The following tools do the preprocessing of the RadMAP system for cartographer:

1. converting velodyne_msgs/VelodyneScan --> sensor_msgs/PointCloud2

2. merging {sensor_msgs/PointCloud2,sensor_msgs/Imu,sensor_msgs/NavSatFix}

3. SE3 aligning 2 velodynes. 

The bagfile names are assumed to be {port,starboard,imu}.bag with the appropriate topic names {/novatel_fix,/novatel_imu,/velodyne_packets_port, /velodyne_packets_starboard}.

Requirements:

1. https://github.com/ros-drivers/velodyne

2. https://github.com/googlecartographer/cartographer_ros

# Merging the bags
1. Place port.bag, starboard.bag, imu.bag into [folder]
2. cd [folder]
3. roslaunch radmap_preprocess lasers.launch 
4. rosrun  rosrun radmap_preprocess lasers 
5. python [path]/src/bag_merge_radmap.py

# Vizualize aligned scans
1. roslaunch radmap_preprocess calibrated_tf.launch
2. rosbag play [bagfile]
3. rviz

# Run cartographer
1. Place configuration files in /params/cartographer_configs in their corresponding cartographer_ros folders
2. roslaunch cartographer_ros demo_radmap.launch bag_filename:=[bagfile path]
3. rosservice call /finish_trajectory [name]
4. roslaunch cartographer_ros assets_writer_radmap.launch bag_filenames:=$[bagfile path] trajectory_filename:=/home/[user]/.ros/[name]
5. cd /home/[user]/ --> point cloud viewer points.ply

# Coordinate frame calibration
1. velodyne_calib.m
2. fill in calibrated_tf.launch
3. roslaunch radmap_preprocess calibrated_tf.launch
4. rosrun tf tf_echo imu_link velodyne_port --> radmap.lau -velodyne_port_joint - origin
5. rosrun tf tf_echo imu_link velodyne_starboard --> radmap.lau - velodyne_starboard_joint - origin
