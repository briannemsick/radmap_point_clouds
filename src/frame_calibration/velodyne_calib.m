% Read the rosbag
clear;clc;close all;

bag = rosbag('velodyne_calib.bag');

port = select(bag, 'Time', ...
[bag.StartTime bag.StartTime + 2], 'Topic', '/points2_1');
board = select(bag, 'Time', ...
[bag.StartTime bag.StartTime + 2], 'Topic', '/points2_2');

min_scans = min(port.NumMessages,board.NumMessages);

port_msgs = readMessages(port);
board_msgs = readMessages(board);

clear bag port board;

% Initial transform
initial_transform = affine3d([rotz(-175.5),[0,0,0]';[0,-2.68,0,1]]);

% Final Transform
final_transform_R = [0,0,0,0];
final_transform_t = [0,0,0];
for ii = 1:min_scans
    port_cloud = pcdownsample(pointCloud(readXYZ(port_msgs{ii})),'gridAverage',.1);
    board_cloud = pcdownsample(pointCloud(readXYZ(board_msgs{ii})),'gridAverage',.1);
    tf= pcregrigid(port_cloud,board_cloud,'InitialTransform',initial_transform, 'Metric', 'pointToPlane', 'Inlier',.6);
    final_transform_R = final_transform_R + 1/min_scans * vrrotmat2vec(tf.T(1:3,1:3));
    final_transform_t = final_transform_t +  1/min_scans * tf.T(4,1:3);
end
final_transform = affine3d([vrrotvec2mat(final_transform_R),[0,0,0]'; final_transform_t,1]);

figure(1);
hold on;
for ii = 1:min_scans
    port_cloud = pcdownsample(pointCloud(readXYZ(port_msgs{ii})),'gridAverage',.1);
    board_cloud = pcdownsample(pointCloud(readXYZ(board_msgs{ii})),'gridAverage',.1);
    temp_cloud = pctransform(port_cloud,final_transform);
    pcshow(temp_cloud.Location,'r');
    pcshow(board_cloud.Location,'b');
end
title('Aligned Starboard and Port Velodyne');
legend('Starboard', 'Port');

% Ground plane
merged_cloud = 0;
for ii = 1:min_scans
    port_cloud = pcdownsample(pointCloud(readXYZ(port_msgs{ii})),'gridAverage',.1);
    board_cloud = pcdownsample(pointCloud(readXYZ(board_msgs{ii})),'gridAverage',.1);
    if merged_cloud ~= 0
        merged_cloud = pcmerge(pctransform(port_cloud,final_transform),merged_cloud, .01);
        merged_cloud = pcmerge(board_cloud,merged_cloud, .01);
    else
        merged_cloud = pcmerge(pctransform(port_cloud,final_transform),board_cloud, .01);
    end
end

figure(2);
hold on;
[model,inlier,outlier] = pcfitplane(merged_cloud,.05);
ground_plane = select(merged_cloud,inlier);
non_ground_plane = select(merged_cloud,outlier);
pcshow(ground_plane.Location,'g');
pcshow(non_ground_plane.Location,'b');
title('Ground plane');
legend('Ground plane', 'non-Ground plane');

% Port Relative to Starboard [x,y,z,q_x,q_y,q_z,q_w]
port = [final_transform.T(4,1:3), rot2quat(final_transform.T(1:3,1:3))']

% Starboard to a Ground Plane [x,y,z,q_x,q_y,q_z,q_w]
A = model.Normal;
if sum(A) < 1
    A = A*-1;
end
B = [0,0,1];
theta = acos(dot(A,B)/(norm(A)*norm(B)));
ground = [0,0,0,rot2quat(vrrotvec2mat([-A(2),A(1),0,theta]))']