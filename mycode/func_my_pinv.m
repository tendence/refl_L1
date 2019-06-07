%%%% --- 根据SVD原理，我们自己完成PINV功能，以便控制 --- %%%%

function [Ainv] = func_my_pinv(A, tol)
[U S V] = svd(A);  % A = USV';
sc = diag(S);
ind = find(sc > sc(1) * tol);
sc_inv = zeros(size(S'));

for k = 1 : length(ind)
    sc_inv(k,k) = 1 / sc(k);
end

Ainv = V * sc_inv * U';

end


