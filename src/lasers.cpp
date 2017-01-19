#include <ros/ros.h>
#include <rosbag/bag.h>
#include <rosbag/view.h>

#include <math.h>

#include <std_msgs/Int32.h>
#include <std_msgs/String.h>

#include <velodyne_pointcloud/rawdata.h>

#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

// velodyne_msgs/VelodyneScan -> pointcloud2
void scan2cloud(const std::string &bag_name, const std::string &input_topic,
				const std::string &output_topic, ros::NodeHandle private_nh,
				const double &min_range = 0.9, const double &max_range = 130, 
 				const double &view_direction = 0.0, const double &view_width = 2*M_PI){
	
	//data_(new velodyne_rawdata::RawData());
	velodyne_rawdata::RawData * data_ = new velodyne_rawdata::RawData();
	data_->setup(private_nh);
	data_->setParameters(min_range, max_range, view_direction, view_width);

	// open input bag
    rosbag::Bag input_bag;
    input_bag.open(bag_name, rosbag::bagmode::Read);

    // create output bag
	std::string output_bag_name = std::string("pc2_").append(bag_name);
	rosbag::Bag output_bag;
 	output_bag.open(output_bag_name, rosbag::bagmode::Write);

    // input topics
    std::vector<std::string> topics;
    topics.push_back(std::string(input_topic));
    rosbag::View view(input_bag, rosbag::TopicQuery(topics));

    // process messages
    foreach(rosbag::MessageInstance const m, view)
    {
    	velodyne_msgs::VelodyneScan::ConstPtr scan_msg = m.instantiate<velodyne_msgs::VelodyneScan>();
    	velodyne_rawdata::VPointCloud::Ptr
      	out_msg(new velodyne_rawdata::VPointCloud());

    	// out_msg's header is a pcl::PCLHeader, convert it before stamp assignment
    	out_msg->header.stamp = pcl_conversions::toPCL(scan_msg->header).stamp;
    	out_msg->header.frame_id = scan_msg->header.frame_id;
   	 	out_msg->height = 1;

    	// process each packet provided by the driver
    	for (size_t i = 0; i < scan_msg->packets.size(); ++i)
      	{
        	data_->unpack(scan_msg->packets[i], *out_msg);
      	}

    	output_bag.write(output_topic,scan_msg->header.stamp, out_msg);
    }

    delete data_;

 	output_bag.close();
	input_bag.close();


}
int main(int argc, char **argv)
{
	ros::init(argc, argv, "lasers");
	ros::NodeHandle node;
  	ros::NodeHandle priv_nh("~");

	ros::start();

	ROS_INFO("STARTING: Processing laser bag files.");

	std::string port_bag, starboard_bag;

	priv_nh.getParam("/port_bag",port_bag);
	scan2cloud(port_bag, "/velodyne_packets_port","points2_1",priv_nh);

	priv_nh.getParam("/starboard_bag",starboard_bag);
	scan2cloud(starboard_bag, "/velodyne_packets_starboard","points2_2",priv_nh);
	
	ROS_INFO("COMPLETED: Processing laser bag files.");

	return 0;
}