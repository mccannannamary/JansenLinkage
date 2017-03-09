function [] = DrawLinkages(nodePositions,linkAngles)
% Draw all links of a Jansen Mechanical Linkage

% input Storage = matrix of the angles each link makes with 
% the x-y axis as the link makes one complete rotation

% input nodePositions = matrix of each node's x and y coordinates as the
% links the nodes are attached to make one complete rotation 

% Version 1: created 4/3/2017. Author: Anna McCann

% -------------------------------------------------------------------------

numArgs = 2;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end
 
% there should be as many frames as there are angles making up one complete rotation
FrameNumber = length(linkAngles);          

crankColour = [1 0 1];
linkColour = [0 1 1];
footprintColour = [1 1 1];
pinColour = [1 1 1];

depth = 5;                  % how far back into z-axis a link goes
z0 = 0;                     % set all links bottom vertices to be at 0 in the z-plane
rpin0 = 2.3;                % fixed pin radius at node 0
rpin1 = 3;                  % fixed pin radius at node 1
rConnectingRod = 2.3;       % radius of rod connecting crank to link_0i

VideoObject = VideoWriter('Jansen.avi');
open(VideoObject);

for angle_count = 1:FrameNumber
    handlefig = figure('Position',[100 100 800 650]);
    axis([-175 50 -200 50 -100 100]);
    light('Position',[-100 -100 -100]);
    light('Position',[100 -100 -100]);
    light('Position',[75 -75 75]);
    axis off
    
    % retreive node n's positions for ease of drawing footprint
    nx = nodePositions(angle_count,15);             
    ny = nodePositions(angle_count,16);
    
    handlepatch_pin0 = DrawNode(nodePositions(angle_count,1),nodePositions(angle_count,2),depth-0.25,2*depth+0.25,rpin0,pinColour);
    handlepatch_pin1 = DrawNode(nodePositions(angle_count,3),nodePositions(angle_count,4),-0.25,depth+0.25,rpin1,pinColour);
    handlepatch_connectingRod = DrawNode(nodePositions(angle_count,5),nodePositions(angle_count,6),-0.25,2*depth+0.25,rConnectingRod,pinColour);

    % variable theta retrieves angle at which the current link should be
    % drawn
    theta = linkAngles(angle_count,1);
    handlepatch_0i = DrawLink(nodePositions(angle_count,1),nodePositions(angle_count,2),nodePositions(angle_count,5),nodePositions(angle_count,6),depth,2*depth,theta,crankColour);

    theta = linkAngles(angle_count,2);
    handlepatch_ij = DrawLink(nodePositions(angle_count,5),nodePositions(angle_count,6),nodePositions(angle_count,7),nodePositions(angle_count,8),z0,depth,theta,linkColour);

    theta = linkAngles(angle_count,3);
    handlepatch_1j = DrawLink(nodePositions(angle_count,3),nodePositions(angle_count,4),nodePositions(angle_count,7),nodePositions(angle_count,8),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,7);
    handlepatch_1m = DrawLink(nodePositions(angle_count,3),nodePositions(angle_count,4),nodePositions(angle_count,11),nodePositions(angle_count,12),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,6);
    handlepatch_im = DrawLink(nodePositions(angle_count,5),nodePositions(angle_count,6),nodePositions(angle_count,11),nodePositions(angle_count,12),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,4);
    handlepatch_1k = DrawLink(nodePositions(angle_count,3),nodePositions(angle_count,4),nodePositions(angle_count,9),nodePositions(angle_count,10),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,5);
    handlepatch_kj = DrawLink(nodePositions(angle_count,9),nodePositions(angle_count,10),nodePositions(angle_count,7),nodePositions(angle_count,8),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,9);
    handlepatch_kl = DrawLink(nodePositions(angle_count,9),nodePositions(angle_count,10),nodePositions(angle_count,13),nodePositions(angle_count,14),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,8);
    handlepatch_ml = DrawLink(nodePositions(angle_count,11),nodePositions(angle_count,12),nodePositions(angle_count,13),nodePositions(angle_count,14),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,11);
    handlepatch_ln = DrawLink(nodePositions(angle_count,13),nodePositions(angle_count,14),nodePositions(angle_count,15),nodePositions(angle_count,16),z0,depth,theta,linkColour);
    
    theta = linkAngles(angle_count,10);
    handlepatch_mn = DrawLink(nodePositions(angle_count,11),nodePositions(angle_count,12),nodePositions(angle_count,15),nodePositions(angle_count,16),z0,depth,theta,linkColour);
    
    % to draw footprint, draw a node for each of node n's positions up to the current angle count
    % there must be a much more efficient way to do this
    for b = 1:angle_count
        nx = nodePositions(b,15);
        ny = nodePositions(b,16);
        handlepatch_footprint = DrawNode(nx,ny,depth,1.25*depth,2,footprintColour);
    end
    
    current_frame = getframe(handlefig);
    writeVideo(VideoObject,current_frame);
    close(handlefig)
end