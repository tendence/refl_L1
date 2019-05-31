function [W, bias, M] = func_wiener_estimation(refl_train, resp_train)

% ����ά�ɹ��Ƶķ������ؽ�

%% STEP 1: �����ͨ����ϵͳ��Ӧ����
[M, bias, resp_pred] = func_spectral_responsivity(refl_train', resp_train');
M = M'; 

%% STEP 2: ��������ˮƽ
resp_train = resp_train - repmat(bias, 1, size(resp_train,2));
resp_noise = resp_train - M * refl_train;
Kn = resp_noise * resp_noise' / size(resp_noise, 2);
Kn = diag(diag(Kn));
K_train = refl_train * refl_train' / size(refl_train, 2);

%% STEP 3: ά�ɹ���
W = K_train * M' * pinv(M * K_train * M' + Kn);

