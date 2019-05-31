function [W] = func_TV1_regu(resp, refl, lambda,tol)

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
D = eye(N-1);
D1=[D,zeros(N-1,1)];
D2=[zeros(N-1,1),-D];
D=D1+D2;

I =eye(N);

R = refl;
X = [resp; ones(1,num)];


DTD=transpose(D)*D;
XTX=X*transpose(X);
YTX=R*transpose(X);
u=0.1;
T=zeros(N-1,num);
rho=1.1;
Z=zeros(N-1,num);
for k=1:50
    u=u*rho;
    W=(I+u*DTD)\(R+u*D'*Z+D'*T)*pinv(X);
    DWX=D*W*X;
    Z=shrinkage(DWX-T/u,lambda/u);
    T=T+u*(Z-DWX);
  % T=T+u*(DWX-Z);
    obj(W,R,X,D,lambda)
end

    function L=obj(W,R,X,D,lambda)
        L=0.5*norm(W*X-R,2)+lambda*norm(D*W*X,1);
    end


function z = shrinkage(x, kappa)
    z = max( 0, x - kappa ) - max( 0, -x - kappa );
end
end