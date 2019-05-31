clear;
    
load weights;
clear a_31 c_31 c_64 d50_31 d50_64 d55_31 d55_64 d65_31  % clear unuseful ill/obs condition
clear d75_31 d75_64 f2_31 f7_31 f7_64 f11_31 f11_64      % clear unuseful ill/obs condition


%% 读入数据
 refl = load('20171030-1119-refl.txt');
 resp = load('20171030-1119-resp.txt');



n = size(refl,1);

% ind_train = 1:round(n/2);
% ind_test = round(n/2)+1:n;
% trainingsamples=50
%  index = randperm(n);
%  ind_train = index(1:trainingsamples);
%  ind_test = index(145:n);

ind_train=1:n;
ind_test=1:n;

refl_train = refl(ind_train,:); resp_train = resp(ind_train,:);
refl_train = refl_train';  resp_train = resp_train';

refl_test = refl(ind_test,:); resp_test = resp(ind_test,:);
refl_test = refl_test';  resp_test = resp_test';


[points, num_train] = size(refl_train);
[channels,num_test] = size(resp_test);



%% 基于伪逆的反射率重建
lambda=0.5;
tol = 0.05;
W = func_pinv_rWu(resp',refl',tol,'normal');
W = func_l1_rWu(resp',refl',tol);

refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
%% 误差
rms = func_batch_rms(refl_test, refl_test_p);
de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
de_f2 = func_batch_cmcde21(refl_test, refl_test_p, 'f2_64');
msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), std(de_d65), max(de_d65));
msg_de_f2   = sprintf('DE_f2:          [%f    %f    %f]',mean(de_f2), std(de_f2), max(de_f2));
msg_rms     = sprintf('mse:   [%f    %f    %f]',mean(rms), std(rms), max(rms));
strvcat(msg_de_d65, msg_de_f2, msg_rms)



