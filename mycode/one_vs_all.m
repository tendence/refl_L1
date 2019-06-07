function one_vs_all()
    categories ={'nylon','paper','cotton','poly'};

%for train_num=[20:1:30,40:10:90,100:100:size(resp,1)]
   for i=1:size(categories,2)
       for j=1:size(categories,2)
            resp_train=load([categories{i},'_resp.txt']);
            refl_train=load([categories{i},'.txt']);
            resp_test=load([categories{j},'_resp.txt']);
            refl_test=load([categories{j},'.txt']);
            W1 = func_l1_rWu(resp_train',refl_train',0.05);
            %W2=func_weighted_pinv_rWu(resp_train',refl_train',0.000001);
            [W2, bias, ~] = func_wiener_estimation(resp_train',refl_train');
            refl_test_p = W1 * [resp_test'; ones(1,size(resp_test',2))];
            %de_d651 = func_batch_rms(refl_test', refl_test_p);
            de_d651 =func_batch_cmcde21(refl_test', refl_test_p, 'f2_64');
            refl_test_p = W2 * [resp_test'; ones(1,size(resp_test',2))];
            de_d652 =func_batch_cmcde21(refl_test', refl_test_p, 'f2_64');
            %de_d652 = func_batch_rms(refl_test', refl_test_p);
            msg_de_d65_l1  = sprintf('%f    %f    %f %f    %f    %f',mean(de_d651), mean(de_d652),...
                std(de_d651), std(de_d652), max(de_d651),max(de_d652));
            
            disp(['train:' categories{i} '           test: ' categories{j} ]);
            disp(msg_de_d65_l1);
        end
    end

