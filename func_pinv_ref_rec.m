function refl_test_p=func_pinv_ref_rec(train_X,train_Y,test_X)
    resp_train=train_X;
    refl_train=train_Y;
    resp_test=test_X;
    W=func_weighted_pinv_rWu(resp_train',refl_train',0.000001);
    refl_test_p = W * [resp_test'; ones(1,size(resp_test',2))];
end