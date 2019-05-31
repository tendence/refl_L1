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

% 确定所选方法
if strcmpi('normal',constraint)          % 正常，无约束条件
    cond = 1;
elseif strcmpi('narrow', constraint)     % 窄带滤光片，计算中将限制有效波段
    cond = 2;
else
    disp('Please specity constraint: normal, narrow'); return;
end

[N, num] = size(refl);   % N: 31      num:数据个数
channel = size(resp,1);      % 相机响应的维数，如: 3, 16, 31
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






















