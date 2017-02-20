![Alt text](images/example_cloud.png?raw=true "Title")


The radmap_point_clouds packages does the following:

1. converts velodyne_msgs/VelodyneScan --> sensor_msgs/PointCloud2

2. merges {sensor_msgs/PointCloud2,sensor_msgs/Imu,sensor_msgs/NavSatFix}

3. Aligns 2 velodynes in SE3 (rotation and translation). 

4. Provides {.lua,.launch,.urdf} configuration files for cartographer

Notes:

1. See installation.txt for step by step guide to build this package.

2. The bagfile names are assumed to be {port,starboard,imu}.bag with the appropriate topic names {/novatel_fix,/novatel_imu,/velodyne_packets_port, /velodyne_packets_starboard}.

Requirements:

1. https://github.com/ros-drivers/velodyne

2. https://github.com/googlecartographer/cartographer_ros

3. http://www.cloudcompare.org/release/

Recommendations (add to .bashrc):

1. source /home/[user]/radmap/internal/devel/setup.bash

2. export RADMAP="/home/[user]/radmap/internal/src/radmap_point_clouds"

3. export RADBAGS="/home/[user]/radmap/internal/src/radmap_point_clouds/bagfiles"

# Merging the bags
1. Place port.bag, starboard.bag, imu.bag into [folder]
2. cd [folder]
3. roslaunch radmap_point_clouds lasers.launch 
4. rosrun radmap_point_clouds lasers 
5. python $RADMAP/src/bag_merging/bag_merge_radmap.py 


# Run cartographer
1. copy params/radmap_config to cartographer/[dev branch]/share/cartographer_ros/radmap_config
2. roslaunch cartographer_ros demo_radmap.launch bag_filename:=${RADMAP}/[bagfile]
3. rosservice call /finish_trajectory [name]
4. roslaunch cartographer_ros assets_writer_radmap.launch bag_filenames:=${RADMAP}/[bagfile] trajectory_filename:=/home/[user]/.ros/[name]
5. cd /home/[user]/ --> CloudCompare --> visualize points.ply

# (Optional) Vizualize aligned scans
1. roslaunch radmap_point_clouds calibrated_tf.launch
2. rosbag play [bagfile]
3. rviz
4. Open rviz/aligned_scans

![Alt text](images/aligned_scans.png?raw=true "Title")
![Alt text](images/coord_frames.png?raw=true "Title")

# (Optional) Coordinate frame calibration
1. velodyne_calib.m
2. fill in calibrated_tf.launch
3. roslaunch radmap_point_clouds calibrated_tf.launch
4. rosrun tf tf_echo imu_link velodyne_port --> radmap.lau - velodyne_port_joint - origin
5. rosrun tf tf_echo imu_link velodyne_starboard --> radmap.lau - velodyne_starboard_joint - origin
