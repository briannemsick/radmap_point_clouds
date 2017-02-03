import rosbag
import numpy as np
import subprocess
import yaml
import matplotlib.pyplot as plt

# Input Bag
imu_yaml = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', 'imu.bag'], stdout=subprocess.PIPE).communicate()[0])

for ii in range(len(imu_yaml['topics'])):
    if imu_yaml['topics'][ii]['topic'] == '/novatel_imu':
        ind = ii
        break
num_msgs = imu_yaml['topics'][ind]['messages']
imu_msgs = np.zeros((6,num_msgs))
t = np.zeros((num_msgs))
imu = rosbag.Bag('imu.bag').read_messages(topics = ['/novatel_imu'])

for ii in range(num_msgs):
    _,msg,stamp = imu.next()
    imu_msgs[0,ii] = msg.angular_velocity.x
    imu_msgs[1,ii] = msg.angular_velocity.y
    imu_msgs[2,ii] = msg.angular_velocity.z
    imu_msgs[3,ii] = msg.linear_acceleration.x
    imu_msgs[4,ii] = msg.linear_acceleration.y
    imu_msgs[5,ii] = msg.linear_acceleration.z
    t[ii] = stamp.to_sec()

plt.plot(t-t[0], imu_msgs[0,:], label =  '$w_x$')
plt.plot(t-t[0], imu_msgs[1,:], label = '$w_y$')
plt.plot(t-t[0], imu_msgs[2,:], label = '$w_z$')
plt.legend(loc='upper center', shadow=True)
plt.xlabel('t (sec)')
plt.ylabel('w rad/s')
plt.show()

plt.plot(t-t[0], imu_msgs[3,:], label =  '$a_x$')
plt.plot(t-t[0], imu_msgs[4,:], label = '$a_y$')
plt.plot(t-t[0], imu_msgs[5,:], label = '$a_z$')
plt.legend(loc='upper center', shadow=True)
plt.xlabel('t (sec)')
plt.ylabel('w rad/s')
plt.show()