import rosbag
import numpy as np
import subprocess
import yaml

def write_msg(input_bag, output_bag, topic, msg, stamp, t_start, t_end):
	try:
		if stamp.to_sec() >= t_start and stamp.to_sec() <= t_end:
			output_bag.write(topic,msg,stamp)
		_, msg, stamp = input_bag.next()
		return stamp.to_sec(), stamp, msg, 
	except:
		return np.inf, np.inf, None


# Output Bag
radmap = rosbag.Bag('merged.bag', 'w')

# Input Bag
starboard_yaml = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', 'starboard.bag'], stdout=subprocess.PIPE).communicate()[0])
port_yaml = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', 'port.bag'], stdout=subprocess.PIPE).communicate()[0])
imu_yaml = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', 'imu.bag'], stdout=subprocess.PIPE).communicate()[0])

port = rosbag.Bag('pc2_port.bag').read_messages()
starboard = rosbag.Bag('pc2_starboard.bag').read_messages()
imu = rosbag.Bag('imu.bag').read_messages()

# Initialize
t = np.zeros(3, dtype = float)
_, msg_p, t_p = port.next()
_, msg_s, t_s = starboard.next()
_, msg_i, t_i = imu.next()

max_start_t = max(starboard_yaml['start'],port_yaml['start'],imu_yaml['start'])
min_end_t = min(starboard_yaml['end'],port_yaml['end'],imu_yaml['end'])

t[0] = t_p.to_sec()
t[1]  = t_s.to_sec()
t[2]  = t_i.to_sec()

while not np.all((t == np.inf)):
	bag_id = np.argmin(t)
	if bag_id == 0:
		t[0],t_p,msg_p = write_msg(port,radmap,'points2_1',msg_p,t_p, max_start_t,min_end_t)

	elif bag_id == 1:
		t[1],t_s,msg_s = write_msg(starboard,radmap,'points2_2',msg_s,t_s, max_start_t,min_end_t)
	
	elif bag_id == 2:
		t[2],t_i,msg_i = write_msg(imu,radmap,'imu',msg_i,t_i, max_start_t,min_end_t)


radmap.close()

print "COMPLETED: Merging bagfiles!"