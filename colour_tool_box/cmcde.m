function [de,dl,dc,dh] = cmcde(lab1,lab2,paral,parac)

% function [de,dl,dc,dh] = cmcde(lab1,lab2,paral,parac)
% computes colour difference from CIELAB values
% using CMC(l:c) formula
% lab1 and lab2 must be 3 by 1 or 1 by 3 matrices
% and contain L*, a* and b* values
% The dl, dc and dh components are CMC deltas
% The defaults for paral and parac are 1
% see also cielabde, cie94de, and cie00de
% In order to make this code self-contained, this code is
% copy from https://ww2.mathworks.cn/matlabcentral/fileexchange/40640-computational-colour-science-using-matlab-2e

dim = size(lab1);
if (dim(1) == 1) | (dim(2) == 1)
   lab1 = lab1(:)'; % force to be a row matrix
else
   disp('lab1 must be a row matrix');
   return;
end
if (dim(2) ~= 3)
   disp('lab1 must be 3 by 1 or 1 by 3');
   return;
end

dim = size(lab2);
if (dim(1) == 1) | (dim(2) == 1)
   lab2 = lab2(:)'; % force to be a row matrix
else
   disp('lab2 must be a row matrix');
   return;
end
if (dim(2) ~= 3)
   disp('lab2 must be 3 by 1 or 1 by 3');
   return;
end

if (nargin<4)
   disp('using default values of l:c')
   paral=1; parac=1;
end

% first compute the CIELAB deltas
dl = lab2(1)-lab1(1);
dc = sqrt(lab2(2)^2 + lab2(3)^2) - sqrt(lab1(2)^2 + lab1(3)^2);
dh = sqrt((lab2(2)-lab1(2))^2 + (lab2(3)-lab1(3))^2 - dc^2);

% get the polarity of the dh term
dh = dh*dhpolarity(lab1,lab2);

% now compute the CMC weights 
if (lab1(1)<16)
   Lweight = 0.511;    
else
   Lweight = (0.040975*lab1(1))/(1 + 0.01765*lab1(1));   
end
[c,h] = car2pol([lab1(2) lab1(3)]); % require C*ab and H*ab of standard
Cweight = 0.638 + (0.0638*c)/(1 + 0.0131*c);
if (164 < h & h < 345)
   k1 = 0.56; k2 = 0.20; k3 = 168;
else
   k1 = 0.36; k2 = 0.40; k3 = 35;
end
T = k1 + abs(k2*cos((h + k3)*pi/180));

F = sqrt((c^4)/(c^4 + 1900));
Hweight = Cweight*(T*F + 1 - F);

dl = dl/(Lweight*paral);
dc = dc/(Cweight*parac);
dh = dh/Hweight;

de = sqrt(dl^2 + dc^2 + dh^2);
