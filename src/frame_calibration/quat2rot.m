%--------------------------------------------------------------------------
% Brian Nemsick
% brian.nemsick@eecs.berkeley.edu
% November 2015
% quat2rot.m
%--------------------------------------------------------------------------
% Purpose: calculate the rotation matrix associated with a quaternion
% Note: See JPL Quaternion Reference
%--------------------------------------------------------------------------

function [R] = quat2rot(q)
    % Precaution to verify q is a unit quaternion
    q = quat_norm(q);
    R = [q(1)^2-q(2)^2-q(3)^2+q(4)^2,2*(q(1)*q(2)+q(3)*q(4)),2*(q(1)*q(3)-q(2)*q(4));...
         2*(q(1)*q(2)-q(3)*q(4)),-q(1)^2+q(2)^2-q(3)^2+q(4)^2,2*(q(2)*q(3)+q(1)*q(4));.... 
         2*(q(1)*q(3)+q(2)*q(4)),2*(q(2)*q(3)-q(1)*q(4)),-q(1)^2-q(2)^2+q(3)^2+q(4)^2];
end



