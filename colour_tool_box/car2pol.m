function [c,h] = car2pol(ab)

% function [c,h] = cartopol(ab)
% converts a*b* or u*v* into the polar coordinates
% of Chroma C and Hue H
% ab must be a row or column matrix 2 by 1 or 1 by 2
% see also pol2car

dim = size(ab);
if (dim(1) == 1) | (dim(2) == 1)
   ab = ab(:)'; % force to be a row matrix
else
   disp('ab must be a row matrix');
   return;
end
if (dim(2) ~= 2)
   disp('ab must be 2 by 1 or 1 by 2');
   return;  
end

% compute the distance from the centre
c = sqrt(ab(1)*ab(1) + ab(2)*ab(2));

% compute the angular term
if (ab(1) == 0) & (ab(2) > 0)
   h = 90;
elseif (ab(1) == 0) & (ab(2) < 0)
   h = 270;
elseif (ab(1) < 0) & (ab(2) == 0)
   h = 180;
elseif (ab(1) > 0) & (ab(2) == 0)
   h = 0;
elseif (ab(1) == 0) & (ab(2) == 0)
   h = 0;
else
   h = atan(abs(ab(2))/abs(ab(1)));
   h = 180*h/pi; % convert from radians to degrees
   if ((ab(1) > 0) & (ab(2) > 0))
      h = h; % first quadrant
   elseif ((ab(1) < 0) & (ab(2) > 0))
      h = 180 - h; % second quadrant
   elseif ((ab(1) < 0) & (ab(2) < 0))
      h = 180 + h; % third quadrant      
   else
      h = 360 - h; % fourth quadrant 
   end
end




















