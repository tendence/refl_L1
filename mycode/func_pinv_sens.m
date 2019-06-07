function [sens, const_bias, resp_pred] = func_pinv_sens(resp, refl, tol)

% function [sens, const_bias, resp_pred] = func_pinv_sens(resp, refl, constraint)
% calculate spectral sensitivity from reflectance and camera response
% Input:
%     resp: camera response, 
%           format: num_num * data_num
%     refl: spectral reflectance, 
%           format: 31 * data_num
%     constraint: normal, narrow
% Output:
%     sens: calculated spectral sensitivity
%     const_bias: regarded as the response of dark current
%     resp_pred:  predicted response using the calculated sensitivity
%
% Important: scale the resp to scale [0, 1]


[N, num] = size(refl);   % N: 31      num:数据个数
channel = size(resp,1);      % 相机响应的维数，如: 3, 16, 31
N1 = N+1;

sens1 = zeros(N1,channel);

% 反射率加上一个常数偏置 1
C = ones(num, N1);
C(:,1:N) = refl';  % 做了转置，因为求解公式是 C x = d，而成像过程为 u = m r，x 为 m 转置


% 求解sensitivity
for i = 1 : channel
    d = resp(i,:);
    d = d';
    x = func_my_pinv(C, tol) * d;
    sens1(:,i) = x;
end

%%% output
resp_pred = (C * sens1)';
sens = sens1(1:N,:)';
const_bias = sens1(end,:)';




























