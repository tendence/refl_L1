function [W] = func_lightness_weighted_pinv_rWu(resp, refl, tol)

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

%% 计算颜色CIELAB数值
illu = 'd65_64';
lab = zeros(3, num);
for i = 1 : num
    xyz = r2xyz(refl(:,i), 400, 700, illu);
    lab(:,i) = xyz2lab(xyz, illu);
end

%% 计算W
L = lab(1,:);
% q = 1 ./ L;
q = (1 ./ L) .^ 2;

R = R .* repmat(q, size(R,1), 1);
U = U .* repmat(q, size(U,1), 1);

W = R * func_my_pinv(U, tol);
    

