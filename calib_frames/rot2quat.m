% Q = ROT2QUAT( R )
%
% This function decomposes a rotation matrix into its quaterion
function q = rot2quat(R)

% Do the decomposition depending on pivot
T = trace(R);
q = zeros(4,1);
if(T > 0)
   S = sqrt(T+1)*2;
   q(4) =  1/4*S;
   q(1) = (R(2,3) - R(3,2)) / S;
   q(2) = (R(3,1) - R(1,3)) / S;
   q(3) = (R(1,2) - R(2,1)) / S;
elseif( (R(1,1) > R(2,2)) && (R(1,1) > R(3,3)) )
   S = sqrt(1 + R(1,1) - R(2,2) - R(3,3)) * 2;
   q(4) = (R(2,3) - R(3,2)) / S;
   q(1) = 1/4*S;
   q(2) = (R(2,1) + R(1,2)) / S;
   q(3) = (R(3,1) + R(1,3)) / S;
elseif (R(2,2) > R(3,3) )
   S = sqrt(1 + R(2,2) - R(1,1) - R(3,3)) * 2;
   q(4) = (R(3,1) - R(1,3)) / S;
   q(1) = (R(2,1) + R(1,2)) / S;
   q(2) = 1/4*S;
   q(3) = (R(3,2) + R(2,3)) / S;
else
   S = sqrt(1 + R(3,3) - R(1,1) - R(2,2)) * 2;
   q(4) = (R(1,2) - R(2,1)) / S;
   q(1) = (R(3,1) - R(1,3)) / S;
   q(2) = (R(3,2) + R(2,3)) / S;
   q(3) = 1/4*S;
end

end