import rosbag
import numpy as np

# Output Bag
radmap = rosbag.Bag('radmap_combined.bag', 'w')

# Input Bag
port = rosbag.Bag('pc2_port.bag').read_messages()
starboard = rosbag.Bag('pc2_starboard.bag').read_messages()

# Initialize
t = np.zeros(2, dtype = float)
topic_p, msg_p, t_p = port.next()
topic_s, msg_s, t_s = starboard.next()

t[0] = t_p.to_sec()
t[1]  = t_s.to_sec()

while not np.all((t == np.inf)):

	bag_id = np.argmin(t)
	
	if bag_id == 0:
		try:
			radmap.write('points2_1', msg_p, t_p)
			_, msg_p, t_p = port.next()
			t[0] = t_p.to_sec()
		except StopIteration:
			t[0] = np.inf

	elif bag_id == 1:
		try:
			radmap.write('points2_2', msg_s, t_s)
			_, msg_s, t_s = starboard.next()
			t[1] = t_s.to_sec()
		except StopIteration:
			t[1] = np.inf

radmap.close()

print "COMPLETED: Merging bagfiles!"