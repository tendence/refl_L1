function [W] = func_pinv_rWu(resp, refl, tol, constraint)

% function [W, const_bias] = func_pinv_rWu(resp, refl, constraint)
% calculate transform matrix between reflectance and response
% Input:
%     resp: camera response, 
%           format: num_num * data_num
%     refl: spectral reflectance, 
%           format: 31 * data_num
%     constraint: normal, narrow
% Output:
%     W: Transform matrix
%     const_bias: regarded as the response of dark current
%
% Important: here we only consider the case of 16 channels
%            W uses an constant bias (resp + 1)
%            scale the resp to scale [0, 1]

% ȷ����ѡ����
if strcmpi('normal',constraint)          % ��������Լ������
    cond = 1;
elseif strcmpi('narrow', constraint)     % խ���˹�Ƭ�������н�������Ч����
    cond = 2;
else
    disp('Please specity constraint: normal, narrow'); return;
end

[N, num] = size(refl);   % N: 31      num:���ݸ���
channel = size(resp,1);      % �����Ӧ��ά������: 3, 16, 31
N1 = N+1;

W = zeros(N, channel+1);

if cond == 1
    
    U = [resp; ones(1,num)];
    W = refl * func_my_pinv(U, tol);
    
elseif cond == 2
    
    step = 2;
    
    for n = 1 : N
        if mod(n,2) == 1
            n1 = (n+1)/2 - step;
            n2 = (n+1)/2 + step;
        else
            n1 = n/2 - (step-1);
            n2 = n/2 + step;
        end
        if n1 < 1
            n1 = 1;
        end
        if n2 > channel
            n2 = channel;
        end
        U = [resp(n1:n2,:); ones(1, num)];
        w = refl(n,:) * func_my_pinv(U, tol);
        W(n,n1:n2) = w(1:end-1);
        W(n,end) = w(end);
    end
    
end






















