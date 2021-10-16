resp_train=load(['paper','_resp.txt']);
refl_train=load(['paper','.txt']);

%train_time
tic
for i=1:20
    WL1= func_l1_rWu(resp_train',refl_train',0.002);
end
toc

tic
for i=1:20
    WL2=func_l2(resp_train',refl_train',0.01);
end
toc

tic
for i=1:20

    [WW, bias, M] = func_wiener_estimation(resp_train',refl_train');
end
toc

tic
for i=1:20
    model=func_gp(resp_train',refl_train',0.001);
end
toc
%test_time

resp_test=resp_train;

tic
for i=1:10000
    refl_test_p = WL1 * [resp_test  ones(size(resp_test,1),1)]';
end
toc

tic
for i=1:10000
    refl_test_p = WL2' * [resp_test  ones(size(resp_test,1),1)]';
end
toc

tic
for i=1:10000

    %[WW, bias, M] = func_wiener_estimation(resp_train',refl_train');
    refl_test_p = WW'* resp_test' ;
end
toc

tic
for i=1:100
     for j=1:31
        knRegPred(model{j}, [resp_test  ones(size(resp_test,1),1)]');
     end
end
toc


