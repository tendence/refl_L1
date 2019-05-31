function [de] = func_refl_cmcde21(f1, f2, illu)

xyz1 = r2xyz(f1, 400, 700, illu);
xyz2 = r2xyz(f2, 400, 700, illu);
lab1 = xyz2lab(xyz1, illu);
lab2 = xyz2lab(xyz2, illu);
de = cmcde(lab1, lab2, 2, 1);

