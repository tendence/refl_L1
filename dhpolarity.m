function [p] = dhpolarity(lab1,lab2)

% function [p] = dhpolarity(lab1,lab2)
% computes polarity of hue difference
% lab1 and lab2 must be 3 by 1 or 1 by 3 matrices
% and contain L*, a* and b* values
% p is +1 if the hue of the trial (lab2) is anticlockwise
% from the standard (lab1) and -1 otherwise


[c1, h1] = car2pol([lab1(2) lab1(3)]);
[c2, h2] = car2pol([lab2(2) lab2(3)]);    
p = (h2-h1);
if (p==0)
    p = 1;
else
    if (p>180)
       p = p - 360;
    end
    p = p/abs(p);
end

