function res= one_vs_all_3_method()
    res=[];
    categories ={'nylon','paper','cotton','poly'};
    %for train_num=[20:1:30,40:10:90,100:100:size(resp,1)]
   %illu='d65_64';
   %illu='f2_64';
    for i=1:size(categories,2)
       for j=1:size(categories,2)
            resp_train=load([categories{i},'_resp.txt']);
            refl_train=load([categories{i},'.txt']);
            resp_test=load([categories{j},'_resp.txt']);
            refl_test=load([categories{j},'.txt']);
            refl_pre_pinv=func_pinv_ref_rec(resp_train,refl_train,resp_test);
            refl_pre_l1=func_l1_ref_rec(resp_train,refl_train,resp_test,0.09);
            refl_wiener_pinv=func_wiener_ref_rec(resp_train,refl_train,resp_test);
            refl_pre_l2=func_l2_ref_rec(resp_train,refl_train,resp_test,0.006);
            refl_pre_ke=func_gp_ref_rec(resp_train,refl_train,resp_test,0.006/100);
             
%             de_pinv =func_batch_cmcde21(refl_test', refl_pre_pinv, illu);
%             de_l1 =func_batch_cmcde21(refl_test', refl_pre_l1, illu);
%             de_wiener =func_batch_cmcde21(refl_test', refl_wiener_pinv, illu);
%             de_l2=func_batch_cmcde21(refl_test', refl_pre_l2, illu);
%             de_kernel=func_batch_cmcde21(refl_test', refl_pre_ke, illu);


            de_pinv =func_batch_rms(refl_test', refl_pre_pinv);
            de_l1 =func_batch_rms(refl_test', refl_pre_l1);
            de_wiener =func_batch_rms(refl_test', refl_wiener_pinv);
            de_l2 =func_batch_rms(refl_test', refl_pre_l2);
            de_kernel=func_batch_rms(refl_test', refl_pre_ke);

            res=[res;...
             mean(de_l1),mean(de_pinv),mean(de_wiener),mean(de_l2),mean(de_kernel),...
                 median(de_l1), median(de_pinv), median(de_wiener),median(de_l2),median(de_kernel),...
                  max(de_l1),max(de_pinv),max(de_wiener),max(de_l2),max(de_kernel)];
            
         %   disp(['train:' categories{i} '           test: ' categories{j} ]);
         %   disp(msg_de_d65_l1);
        end
    end
%    csvwrite([illu,'.csv'],res);
   csvwrite('rms.csv',res);
