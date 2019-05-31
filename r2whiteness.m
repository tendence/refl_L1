function whiteness = r2whiteness(p, startlam, endlam, obs)
xyz = r2xyz(p, startlam, endlam, obs);
mysum = sum(xyz);
x0 = xyz(1)/mysum;
y0 = xyz(2)/mysum;
whiteness = xyz(2) + 800 * (0.3138 - x0) + 1700 * (0.3310 - y0);



