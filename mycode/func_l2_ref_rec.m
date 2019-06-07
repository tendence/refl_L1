function refl_test_p=func_l2_ref_rec(train_X,train_Y,test_X,lambda)
    resp_train=train_X;
    refl_train=train_Y;
    resp_test=test_X;
    W=func_l2(resp_train',refl_train',lambda);
    refl_test_p = W' * [resp_test'; ones(1,size(resp_test',2))];
end