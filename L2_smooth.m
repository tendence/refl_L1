function output=L2_smooth(refl,lambda)
[N, num] = size(refl);   % N: 31      num:数据个数
D = eye(N-1);
D1=[D,zeros(N-1,1)];
D2=[zeros(N-1,1),-D];
D=D1+D2;

I =eye(N);

R = refl;


% q = ones(1, size(R,2));
% mvalue = max(R, [], 1);
% q(mvalue < 0.2) = 100;

%R = R .* repmat(q, size(R,1), 1);
%U = U .* repmat(q, size(U,1), 1);


output =inv(I+lambda*transpose(D)*D) *R;