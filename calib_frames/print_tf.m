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