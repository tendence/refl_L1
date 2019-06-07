function [W, bias, M] = func_wiener_estimation(refl_train, resp_train)

% 基于维纳估计的反射率重建

%% STEP 1: 计算各通道的系统响应函数
[M, bias, resp_pred] = func_spectral_responsivity(refl_train', resp_train');
M = M'; 

%% STEP 2: 估计噪声水平
resp_train = resp_train - repmat(bias, 1, size(resp_train,2));
resp_noise = resp_train - M * refl_train;
Kn = resp_noise * resp_noise' / size(resp_noise, 2);
Kn = diag(diag(Kn));
K_train = refl_train * refl_train' / size(refl_train, 2);

%% STEP 3: 维纳估计
W = K_train * M' * pinv(M * K_train * M' + Kn);

