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


[N, num] = size(refl);   % N: 31      num:���ݸ���
channel = size(resp,1);      % �����Ӧ��ά������: 3, 16, 31
N1 = N+1;

sens1 = zeros(N1,channel);

% �����ʼ���һ������ƫ�� 1
C = ones(num, N1);
C(:,1:N) = refl';  % ����ת�ã���Ϊ��⹫ʽ�� C x = d�����������Ϊ u = m r��x Ϊ m ת��


% ���sensitivity
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




























