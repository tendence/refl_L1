code and data for &ltSpectral reflectance reconstruction using L1-norm penalization for colour reproduction &gt
========================================================================
data:

poly.txt: spectral data for all the polyester samples measured by Spectralphotometer.
![avatar](/image/poly.bmp)

paper.txt: spectral data for all the polyester samples measured by Spectralphotometer.
![avatar](/image/paper.png)

cotton.txt: spectral data for all the polyester samples measured by Spectralphotometer.
![avatar](/image/cotton.bmp)

nylon.txt: spectral data for all the polyester samples measured by Spectralphotometer.
![avatar](/image/nylon.png)

These data are 31-d data.


poly_resp.txt, paper_resp.txt, cotton_resp.txt, nylon_resp.txt: response data by MSI (multispectral imaging system).
These data are 16-d data.

Code:

importance script:
one_vs_3_method.m are the script file that runs the caparision.

important function:

func_pinv_ref_rec.m   pseudo-inverse for reflectance reconstruction ;

func_l1_ref_rec.m  L1-norm penalization for reflectance reconstruction;

func_wiener_ref_rec.m  Wiener estimation for reflectance reconstruction; 

func_l2_ref_rec.m L2-norm for reflectance reconstruction;

func_gp_ref_rec.m Kernel method for reflectance reconstruction;

func_batch_rms.m batch estimation of rms.

func_batch_cmcde21.m batch estimation of color difference of $\Delta E_{cmc(2:1)}$
 