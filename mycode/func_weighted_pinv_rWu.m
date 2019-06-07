function [W] = func_weighted_pinv_rWu(resp, refl, tol)

% function [W, const_bias] = func_pinv_rWu(resp, refl, tol, cmf)
% calculate transform matrix between reflectance and response
% Input:
%     resp: camera response, 
%           format: num_num * data_num
%     refl: spectral reflectance, 
%           format: 31 * data_num
%     cmf: weighting: colr matching function
% Output:
%     W: Transform matrix
%     const_bias: regarded as the response of dark current
%
% Important: here we only consider the case of 16 channels
%            W uses an constant bias (resp + 1)
%            scale the resp to scale [0, 1]


[N, num] = size(refl);   % N: 31      num:数据个数

R = refl;
U = [resp; ones(1,num)];

q = 1 ./ max(R,[],1);

% q = ones(1, size(R,2));
% mvalue = max(R, [], 1);
% q(mvalue < 0.2) = 100;

R = R .* repmat(q, size(R,1), 1);
U = U .* repmat(q, size(U,1), 1);

W = R * func_my_pinv(U, tol);
    




