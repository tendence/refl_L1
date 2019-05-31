function refl_test_p=func_gp_ref_rec(train_X,train_Y,test_X,lambda)
    resp_train=train_X';
    refl_train=train_Y';
    resp_test=test_X';
    model=func_gp(resp_train,refl_train,lambda);
    %refl_test_p = W * [resp_test'; ones(1,size(resp_test',2))];
    
    for i=1:31
        refl_test_p(:,i)=knRegPred(model{i},[resp_test;ones(1,size(resp_test,2))]);
    end
    refl_test_p=refl_test_p';
    
end