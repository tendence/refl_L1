resp_train=load(['cotton','_resp.txt']);
refl_train=load(['cotton','.txt']);
resp_test=load(['paper','_resp.txt']);
refl_test=load(['paper','.txt']);
% refl_pre_pinv=func_pinv_ref_rec(resp_train,refl_train,resp_test);
% refl_pre_l1=func_l1_ref_rec(resp_train,refl_train,resp_test);
% refl_wiener_pinv=func_wiener_ref_rec(resp_train,refl_train,resp_test);
refl_pre_gp=func_gp_ref_rec(resp_train',refl_train',resp_test');