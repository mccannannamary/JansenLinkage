function [ handlepatch ] = DrawNode(x0,y0,z0,z1,r,color)
% draw crossbar link with provided x,y coordinates

numArgs = 6;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end

N = 100;    % number of distinct points around the link

x0 = x0*ones(N,1);
y0 = y0*ones(N,1);
zb = z0*ones(N,1);
zt = z1*ones(N,1);

theta = [0:2*pi/N:(2*pi)-(2*pi/N)]';

v_bottom = [ [r*cos(theta)+x0] zb [r*sin(theta)+y0] ];
v_top = [ [r*cos(theta)+x0] zt [r*sin(theta)+y0] ];
vertex_matrix = [v_bottom;v_top];
face_matrix = [[1:N];[1:N]' [[2:N] 1]' [(N+[2:N]) N+1]' ((N+[1:N])')*ones(1,N-3);N+[1:N]];

handlepatch = patch('Vertices',vertex_matrix,'Faces',face_matrix,'FaceColor',color,'LineStyle','none');

end




