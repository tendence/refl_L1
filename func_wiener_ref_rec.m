function refl_test_p=func_wiener_ref_rec(train_X,train_Y,test_X)
    resp_train=train_X';
    refl_train=train_Y';
    resp_test=test_X';
    %% �����ͨ����ϵͳ��Ӧ����
    [M, bias, resp_pred] = func_pinv_sens(resp_train, refl_train, 1e-3);



    %% ��������ˮƽ
    resp_train = resp_train - repmat(bias, 1, size(resp_train,2));
    resp_noise = resp_train - M * refl_train;
    Kn = resp_noise * resp_noise' / size(resp_noise, 2);
    % sigma = mean(diag(Kn));
    % Kn = sigma * eye(channels);
    Kn = diag(diag(Kn));
    K_train = refl_train * refl_train' / size(refl_train, 2);


    %% ά�ɹ���
    W = K_train * M' * pinv(M * K_train * M' + Kn);


    %% ���׷�����Ԥ��
    refl_test_p = W * (resp_test - repmat(bias, 1, size(resp_test,2)));
end