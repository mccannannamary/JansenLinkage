function [ handlepatch ] = DrawLink(x0,y0,x1,y1,z0,z1,theta3,colour)
% Draw one link at a specific position and angle 

% inputs x0,y0,z0 = x,y and z coordinates of bottom vertices of link
% inputs x1,y1,z1 = x,y and z coordinates of top vertices of link
% input theta3 = angle link should make with x-y axis 
% input colour = colour of link

% Version 1: created 8/3/2017. Author: Anna McCann

% -------------------------------------------------------------------------


numArgs = 8;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end

N = 100;                % number of distinct points around the link
r = 2;                  % radius at round edges of link - how far the vertices are from the actual x,y coordinates

% half of the vertices of the link should be at x0,y0. The other half
% should be at x1,y1
x0 = x0*ones(N/2,1);    
y0 = y0*ones(N/2,1);
x1 = x1*ones(N/2,1);
y1 = y1*ones(N/2,1);

% z coordinates set the depth of the link
zb = z0*ones(N,1);
zt = z1*ones(N,1);

% theta is used to draw the vertices about the x and y coordinates
% half the vertices (left side of link) are drawn rougly from angles pi/2 to 3*pi/2 (theta1)
% while the other half (right side of link) are drawn from angles 3*pi/2 to pi/2 (theta2)
theta = [0:2*pi/N:(2*pi)-(2*pi/N)]';
theta1 = theta(N/4+1:3*N/4);
theta2 = [theta(3*N/4+1:N);theta(1:N/4)];

% the two sets of vertices are the exact same, and are separated by zt - zb
% which sets the depth of the link
v_bottom = [ [r*cos(theta1)+x0;r*cos(theta2)+x1] zb [r*sin(theta1)+y0;r*sin(theta2)+y1] ];
v_top = [ [r*cos(theta1)+x0;r*cos(theta2)+x1] zt [r*sin(theta1)+y0;r*sin(theta2)+y1] ];
vertex_matrix = [v_bottom;v_top];

% faces - this code was taken from Sim2 lecture notes
face_matrix = [[1:N];[1:N]' [[2:N] 1]' [(N+[2:N]) N+1]' ((N+[1:N])')*ones(1,N-3);N+[1:N]];

% set up rotation matrix - this code was also taken from Sim2 lecture notes
Rtheta = [1 0 0; 0 cos(theta3) sin(theta3);0 -sin(theta3) cos(theta3)];

% rotate every vertex by angle theta3 - from Sim2 lecture notes
for count = 1:2*N
    vertices_matrix_rotated(count,:) = (Rtheta*(vertex_matrix(count,:)'))';
end

handlepatch = patch('Vertices',vertex_matrix,'Faces',face_matrix,'FaceColor',colour,'LineStyle','none');

end

