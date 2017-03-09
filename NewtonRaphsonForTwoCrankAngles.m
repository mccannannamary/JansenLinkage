function [ theta1,theta2,count ] = NewtonRaphsonForTwoCrankAngles(a,b,x1_0,x2_0,c1,c2)
% Find two unknown angles that a link makes with the x-y axis as part of 
% a Jansen mechanical linkage, using the Newton-Raphson method to solve for 
% the two unknowns x1_0 and x2_0 in equations of the following form:

% a*cos(x1_0) + b*cos(x2_0) + c1 = 0
% a*sin(x1_0) + b*sin(x2_0) + c2 = 0

% inputs x1_0 and x2_0 - initial guesses of crank angles to be
% solved for. These were determined by measuring each angle by hand

% inputs a,b,c1 and c2  - constant values for duration of this instance of the 
% Newton Raphson algorithm

% outputs theta1, theta2 - values of angles that Newton-Raphson
% method converges to

% output count - how many iterations Newton-Raphson takes to converge

% Version 1: created 28/2/2017. Author: Anna McCann

% -------------------------------------------------------------------------

numArgs = 6;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end

% set Newton-Raphson algorithm parameters
tolerance = 10^-5;      % minimum absolute value of fZ required before algorithm converges
iterationLimit = 100;   % how many iterations may run before algorithm 'gives up'

% set unknown values x1 and x2 to be initial guesses provided
x1 = x1_0;
x2 = x2_0;
x = [x1;x2];

% set up Newton-Raphson equations for which crank angles are to be found
f1 = a*cos(x(1)) +  b*cos(x(2)) + c1;
f2 = a*sin(x(1)) + b*sin(x(2)) + c2;
f = [f1;f2];

% set up Jacobian matrix - required for Newton-Raphson algorithm
df1x1 = -a*sin(x(1));
df1x2 = -b*sin(x(2));
df2x1 = a*cos(x(1));
df2x2 = b*cos(x(2));
Df = [df1x1 df1x2;df2x1 df2x2];

for countn = 0:iterationLimit
    if countn == iterationLimit
        error('Newton-Raphson did not converge for the iteration limit');
        break
    end
    
    % Newton-Raphson has converged when the value of the function f is very
    % near 0
    if abs(f) < tolerance
        break
    else
        x = x - inv(Df)*f;
    
        % update Newton-Raphson equations with new values of x1 and x2
        f1 = a*cos(x(1)) +  b*cos(x(2)) + c1;
        f2 = a*sin(x(1)) + b*sin(x(2)) + c2;
        f = [f1;f2];

        % update Jacobian matrix
        df1x1 = -a*sin(x(1));
        df1x2 = -b*sin(x(2));
        df2x1 = a*cos(x(1));
        df2x2 = b*cos(x(2));
        Df = [df1x1 df1x2;df2x1 df2x2];
    end

% assign output values
count = countn;
theta1 = x(1);
theta2 = x(2);
end
