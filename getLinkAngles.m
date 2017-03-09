function [linkAngles,nodePositions] = getLinkAngles(N)
%% function to run NewtonRaphsonForTwoCrankAngles for required number of closure equations. 
%  This function will use values solved for by previous iterations of the function and
%  provide as parameters to future iterations of the function
%  input N = number of divisions of 2pi radians to take
%  output Storage = matrix of all the link angles



numArgs = 1;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end

% set constant link length values; 
L_0i = 15;
L_ij = 50;
L_01x = 38;
L_01y = 7.8;
L_1j = 41.5;
L_1k = 40.1;
L_kj = 55.8;
L_im = 61.9;
L_1m = 39.3;
L_ml = 36.7;
L_kl = 39.4;
L_mn = 49;
L_ln = 65.7;

count = zeros(N,5);
deg2rad = pi/180;

% create vector to describe N positions of the crank angle
crankAngle = [0:2*pi/N:2*pi-2*pi/N]+35*deg2rad;


%% 1. Solve for theta_ij and theta_1j

% first closure equation - solve for theta_ij and theta_1j
theta_ij = ones(1,N)*150*deg2rad;         % initial guess for theta_ij
theta_1j = ones(1,N)*80*deg2rad;          % initial guess for theta_1j
c1 = L_0i*cos(crankAngle) + 38;           % constant for equation
c2 = L_0i*sin(crankAngle) + 7.8;          % constant for second equation
a = L_ij;                                 % known length of link i_j
b = -L_1j;                                % known length of link 1_j

% run Newton-Raphson once with initial guess based on geometry of the
% linkages
[theta_ij(1),theta_1j(1),count(1,1)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_ij(1),theta_1j(1),c1(1),c2(1));    % 
% run for remaining crank angles to complete full revolution
for m = 2:N
    [theta_ij(m),theta_1j(m),count(m,1)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_ij(m-1),theta_1j(m-1),c1(m),c2(m));
end

%% 2. Solve for theta_kj and theta_1k
% set up constants
c1 = -L_1j*cos(theta_1j);
c2 = -L_1j*sin(theta_1j);
a = L_1k;
b = L_kj;
theta_1k = ones(1,N)*165*deg2rad;           % initial guess based on geo.
theta_kj = ones(1,N)*35*deg2rad;            % initial guess based on geo. 

% run Newton-Raphson once with initial guess based on geometry of the
% linkages
[theta_1k(1),theta_kj(1),count(1,2)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_1k(1),theta_kj(1),c1(1),c2(1));    % 
for m = 2:N
    [theta_1k(m),theta_kj(m),count(m,2)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_1k(m-1),theta_kj(m-1),c1(m),c2(m));
end

%% 3. Solve for theta_1m and theta_im
% set up constants
c1 = L_0i*cos(crankAngle)+38;
c2 = L_0i*sin(crankAngle)+7.8;
a = -L_im;
b = L_1m;
theta_im = ones(1,N)*55*deg2rad;          
theta_1m = ones(1,N)*114*deg2rad;         

% run Newton-Raphson once with initial guess based on geometry of the
% linkages
[theta_im(1),theta_1m(1),count(1,3)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_im(1),theta_1m(1),c1(1),c2(1));     
for m = 2:N
    [theta_im(m),theta_1m(m),count(m,3)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_im(m-1),theta_1m(m-1),c1(m),c2(m));
end

%% 4. Solve for theta_ml and theta_kl
c1 = -L_1m*cos(theta_1m)-L_1k*cos(theta_1k);
c2 = -L_1m*sin(theta_1m)-L_1k*sin(theta_1k);
a = L_ml;
b = L_kl;
theta_ml = ones(1,N)*160*deg2rad;            % REPLACE WITH MEASURED ANGLES
theta_kl = ones(1,N)*120*deg2rad;            % REPLACE WITH MEASURED ANGLES

% run Newton-Raphson once with initial guess based on geometry of the
% linkages
[theta_ml(1),theta_kl(1),count(1,4)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_ml(1),theta_kl(1),c1(1),c2(1));    % 
for m = 2:N
    [theta_ml(m),theta_kl(m),count(m,4)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_ml(m-1),theta_kl(m-1),c1(m),c2(m));
end

%% 5. Solve for theta_mn and theta_ln
c1 = -L_ml*cos(theta_ml);
c2 = -L_ml*sin(theta_ml);
a = -L_mn;
b = L_ln;
theta_mn = ones(1,N)*80*deg2rad;            
theta_ln = ones(1,N)*112*deg2rad;           

% run Newton-Raphson once with initial guess based on geometry of the
% linkages
[theta_mn(1),theta_ln(1),count(1,5)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_mn(1),theta_ln(1),c1(1),c2(1));     
for m = 2:N
    [theta_mn(m),theta_ln(m),count(m,4)] = NewtonRaphsonForTwoCrankAngles(a,b,theta_mn(m-1),theta_ln(m-1),c1(m),c2(m));
end

linkAngles = [crankAngle;theta_ij;theta_1j;theta_1k;theta_kj;theta_im;theta_1m;theta_ml;theta_kl;theta_mn;theta_ln]';

%% get Node positions for each angle
n0 = [zeros(N,1) zeros(N,1)];          % node 0 is fixed, and is the reference point
n1 = [-38*ones(N,1) -7.8*ones(N,1)];   % node 1 is also fixed

ni = nodePositionsForEachAngle(L_0i,crankAngle',n0(:,1),n0(:,2));
nj = nodePositionsForEachAngle(L_ij,theta_ij',ni(:,1),ni(:,2));
nk = nodePositionsForEachAngle(L_1k,theta_1k',n1(:,1),n1(:,2));

nm = nodePositionsForEachAngle(-L_im,theta_im',ni(:,1),ni(:,2));
nn = nodePositionsForEachAngle(-L_mn,theta_mn',nm(:,1),nm(:,2));
nl = nodePositionsForEachAngle(L_ml,theta_ml',nm(:,1),nm(:,2));

nodePositions = [n0 n1 ni nj nk nm nl nn];
