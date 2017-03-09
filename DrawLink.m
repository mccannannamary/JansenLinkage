function [ handlepatch ] = DrawLink(x0,y0,x1,y1,z0,z1,theta3,color)
% draw crossbar link with provided x,y coordinates


numArgs = 8;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end

N = 100;    % number of distinct points around the link
depth = 5;
r = 2;

x0 = x0*ones(N/2,1);
y0 = y0*ones(N/2,1);
x1 = x1*ones(N/2,1);
y1 = y1*ones(N/2,1);

zb = z0*ones(N,1);
zt = z1*ones(N,1);

theta = [0:2*pi/N:(2*pi)-(2*pi/N)]';
theta1 = theta(N/4+1:3*N/4);
theta2 = [theta(3*N/4+1:N);theta(1:N/4)];

v_bottom = [ [r*cos(theta1)+x0;r*cos(theta2)+x1] zb [r*sin(theta1)+y0;r*sin(theta2)+y1] ];
v_top = [ [r*cos(theta1)+x0;r*cos(theta2)+x1] zt [r*sin(theta1)+y0;r*sin(theta2)+y1] ];
vertex_matrix = [v_bottom;v_top];
face_matrix = [[1:N];[1:N]' [[2:N] 1]' [(N+[2:N]) N+1]' ((N+[1:N])')*ones(1,N-3);N+[1:N]];

Rtheta = [1 0 0; 0 cos(theta3) sin(theta3);0 -sin(theta3) cos(theta3)];
for count = 1:2*N
    vertices_matrix_rotated(count,:) = (Rtheta*(vertex_matrix(count,:)'))';
end

handlepatch = patch('Vertices',vertex_matrix,'Faces',face_matrix,'FaceColor',color,'LineStyle','none');

end

