function [xyz] = r2xyz(p, startlam, endlam, obs)

% function [xyz] = r2xyz(p, startlam, endlam, obs)
% computes XYZ from reflectance p using a table of weights
% operates on matrix p of dimensions 1 by n for 
% illuminants A, C, D50, D55, D65, D75, F2, F7, F9
% and for the 1931 and 1964 observers
% set obs to 'd65_64 for D65 and 1964, for example
% the startlam and endlam variables denote the first and 
% last wavelengths (eg. 400 and 700) for your reflectance
% which must be integers of 10 in the range 360-780

if ((endlam>780) | (startlam<360) | (rem(endlam,10)~=0) | (rem(startlam,10)~=0))
   disp('start and end wavelengths must be divisible by 10')
   disp('wavelength range must be 360-780 or less'); return;   
end

load weights.mat % weights.mat contains the tables of weights
if strcmp('a_64',obs)
   cie = a_64;
elseif strcmp('a_31', obs)
   cie = a_31; 
elseif strcmp('c_64', obs)
   cie = c_64; 
elseif strcmp('c_31', obs)
   cie = c_31; 
elseif strcmp('d50_64', obs)
   cie = d50_64; 
elseif strcmp('d_50', obs)
   cie = d_50; 
elseif strcmp('d55_64', obs)
   cie = d55_64; 
elseif strcmp('d55_31', obs)
   cie = d55_31; 
elseif strcmp('d65_64', obs)
   cie = d65_64; 
elseif strcmp('d65_31', obs)
   cie = d65_31; 
elseif strcmp('d75_64', obs)
   cie = d75_64; 
elseif strcmp('d75_31', obs)
   cie = d75_31; 
elseif strcmp('f2_64', obs)
   cie = f2_64; 
elseif strcmp('f2_31', obs)
   cie = f2_31; 
elseif strcmp('f7_64', obs)
   cie = f7_64; 
elseif strcmp('f7_31', obs)
   cie = f7_31; 
elseif strcmp('f9_64', obs)
   cie = f9_64; 
elseif strcmp('f9_31', obs)
   cie = f9_31; 
elseif strcmp('f11_64', obs)
   cie = f11_64; 
% elseif strcmp('f11_31', obs)
%    cie = f11_31; 
else
   disp('unknown option obs'); 
   disp('use d65_64 for D65 and 1964 observer'); return;
end

% check dimensions of P
dim = size(p);
if (dim(1) == 1) | (dim(2) == 1)
   p = p(:)'; % force to be a row matrix
else
   disp('p must be a row matrix');
   return;
end

N = ((endlam-startlam)/10 + 1);
if (length(p) ~= N)
   disp('check dimensions of p'); return;   
end

% deal with possible truncation of reflectance
index1 = (startlam - 360)/10 + 1;
if (index1>1)
   cie(index1,:) = cie(index1,:) + sum(cie(1:index1-1,:));
end
index2 = index1 + N - 1;
if (index2<43)
   cie(index2,:) = cie(index2,:) + sum(cie(index2+1:43,:));
end
cie = cie(index1:index2,:);

xyz = (p*cie)*100/sum(cie(:,2));
% note that 100//sum(cie(:,2)) is the normalisiong factor k
% so that Y = 100 for a perfect reflecting diffuser














