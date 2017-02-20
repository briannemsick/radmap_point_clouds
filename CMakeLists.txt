cmake_minimum_required(VERSION 2.8.3)
project(radmap_point_clouds)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  rosbag
  std_msgs
  velodyne_msgs
  velodyne_pointcloud
)

find_package(Boost REQUIRED COMPONENTS thread)

generate_messages(
   DEPENDENCIES
   std_msgs   velodyne_msgs
 )

catkin_package()

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(lasers src/lasers.cpp)
target_link_libraries(lasers ${catkin_LIBRARIES})
add_dependencies(lasers radmap_point_clouds_generate_messages_cpp)