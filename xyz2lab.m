function [lab] = xyz2lab(xyz,obs)

% function [lab] = xyz2lab(xyz,obs)
% computes CIELAB LAB values from XYZ tristimulus values
% requires the illuminant/observer obs to define white point
% see function r2xyz for valid values for obs

if strcmp('a_64',obs)
    white=[111.144 100.00 35.200];
elseif strcmp('a_31', obs)
    white=[109.074 100.00 35.585];
elseif strcmp('c_64', obs)
    white=[97.285 100.00 116.145];
elseif strcmp('c_31', obs)
    white=[98.074 100.00 118.232];
elseif strcmp('d50_64', obs)
    white=[96.720 100.00 81.427];
elseif strcmp('d_50', obs)
    white=[96.422 100.00 82.521];
elseif strcmp('d55_64', obs)
    white=[95.799 100.00 90.926];
elseif strcmp('d55_31', obs)
    white=[95.682 100.00 92.149];
elseif strcmp('d65_64', obs)
    white=[94.811 100.00 107.304];
elseif strcmp('d65_31', obs)
    white=[95.047 100.00 108.883];
elseif strcmp('d75_64', obs)
    white=[94.416 100.00 120.641];
elseif strcmp('d75_31', obs)
    white=[94.072 100.00 122.638];
elseif strcmp('f2_64', obs)
    white=[103.279 100.00 69.027];
elseif strcmp('f2_31', obs)
    white=[99.186 100.00 67.393];
elseif strcmp('f7_64', obs)
    white=[95.792 100.00 107.686];
elseif strcmp('f7_31', obs)
    white=[95.041 100.00 108.747];
elseif strcmp('f11_64', obs)
    white=[103.863 100.00 65.607]; 
elseif strcmp('f11_31', obs)
    white=[100.962 100.00 64.350];
else
   disp('unknown option obs'); 
   disp('use d65_64 for D65 and 1964 observer'); return;
end

dim = size(xyz);
if (dim(1) == 1) | (dim(2) == 1)
   xyz = xyz(:)'; % force to be a row matrix
else
   disp('xyz must be a row matrix');
   return;
end

if (xyz(2)/white(2) > 0.008856)
   lab(1) = 116*(xyz(2)/white(2))^(1/3) - 16;  
else
   lab(1) = 903.3*(xyz(2)/white(2));   
end

for i=1:3
   if (xyz(i)/white(i) > 0.008856)
      fx(i) = (xyz(i)/white(i))^(1/3);   
   else
      fx(i) = 7.787*(xyz(i)/white(i)) + 16/116;   
   end
end

lab(2) = 500*(fx(1)-fx(2));
lab(3) = 200*(fx(2)-fx(3));

















