clear;
    
load weights;
clear a_31 c_31 c_64 d50_31 d50_64 d55_31 d55_64 d65_31  % clear unuseful ill/obs condition
clear d75_31 d75_64 f2_31 f7_31 f7_64 f11_31 f11_64      % clear unuseful ill/obs condition


%% 读入数据
refl = load('refl.txt');
resp = load('resp.txt');

channels1=[1,8,16];%3
channels2=[1,4,8,13,16];%6
channels3=[1,3,5,7,9,11,13,15];%8

n = size(refl,1);

% ind_train = 1:round(n/2);
% ind_test = round(n/2)+1:n;


ind_train = 1:n;
ind_test = 1:n;

refl_train = refl(ind_train,:); resp_train = resp(ind_train,:);
refl_train = refl_train';  resp_train = resp_train';

refl_test = refl(ind_test,:); resp_test = resp(ind_test,:);
refl_test = refl_test';  resp_test = resp_test';


[points, num_train] = size(refl_train);
[channels,num_test] = size(resp_test);



%% 计算各通道的系统响应函数
[M, bias, resp_pred] = func_pinv_sens(resp_train, refl_train, 1e-3);



%% 估计噪声水平
resp_train = resp_train - repmat(bias, 1, size(resp_train,2));
resp_noise = resp_train - M * refl_train;
Kn = resp_noise * resp_noise' / size(resp_noise, 2);
% sigma = mean(diag(Kn));
% Kn = sigma * eye(channels);
Kn = diag(diag(Kn));
K_train = refl_train * refl_train' / size(refl_train, 2);


%% 维纳估计
W = K_train * M' * pinv(M * K_train * M' + Kn);


%% 光谱反射率预测
refl_test_p = W * (resp_test - repmat(bias, 1, size(resp_test,2)));
    



%% 光谱及色度误差计算

rms = func_batch_rms(refl_test, refl_test_p);
de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
de_f2 = func_batch_cmcde21(refl_test, refl_test_p, 'f2_64');

msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), median(de_d65), max(de_d65));
msg_de_f2   = sprintf('DE_f2:          [%f    %f    %f]',mean(de_f2), median(de_f2), max(de_f2));
msg_rms     = sprintf('spectral mse:   [%f    %f    %f]',mean(rms), median(rms), max(rms));

strvcat(msg_de_d65, msg_de_f2, msg_rms)

