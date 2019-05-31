illu={'a_64','c_64','d50_64','d65_64','f2_64'};

resp_train=load(['cotton','_resp.txt']);
refl_train=load(['cotton','.txt']);
resp_test=load(['paper','_resp.txt']);
refl_test=load(['paper','.txt']);



            refl_pre_pinv=func_pinv_ref_rec(resp_train,refl_train,resp_test);
            refl_pre_l1=func_l1_ref_rec(resp_train,refl_train,resp_test,0.09);
            refl_wiener_pinv=func_wiener_ref_rec(resp_train,refl_train,resp_test);
            refl_pre_l2=func_l2_ref_rec(resp_train,refl_train,resp_test,0.006);
            refl_pre_kernel=func_gp_ref_rec(resp_train,refl_train,resp_test,0.006/100);
            
            
            

de_pinv=[];
de_l1=[];
de_wiener=[];
de_l2=[];
de_kernel=[];
de_rms_l1=func_batch_rms(refl_test', refl_pre_l1);
de_rms_pinv=func_batch_rms(refl_test', refl_pre_pinv);
de_rms_wiener=func_batch_rms(refl_test', refl_wiener_pinv);
de_rms_l2=func_batch_rms(refl_test', refl_pre_l2);
de_rms_kernel=func_batch_rms(refl_test', refl_pre_kernel);

for i=1:size(illu,2)
    de_pinv(i,:)=func_batch_cmcde21(refl_test', refl_pre_pinv, illu(i));
    de_l1(i,:)=func_batch_cmcde21(refl_test', refl_pre_l1, illu(i));
    de_wiener(i,:)=func_batch_cmcde21(refl_test', refl_wiener_pinv, illu(i));
    de_l2(i,:)=func_batch_cmcde21(refl_test', refl_pre_l2, illu(i));
    de_kernel(i,:)=func_batch_cmcde21(refl_test', refl_pre_kernel, illu(i));
end

% for i=1:size(resp_test,1)
%     flag=1;
%    for j=1:size(illu,2) 
%         if(de_l1(j,i)>de_pinv(j,i)) 
%             flag=0;
%             continue;
%         end
%         if(de_l1(j,i)>de_wiener(j,i)) 
%             flag=0;
%             continue;
%         end
%    end
%    if(flag==1)
%        disp(i)
%    end
% end

for i=1:size(resp_test,1)
    flag=1;
    for j=1:size(illu,2) 
        if min([de_l1(j,i),de_pinv(j,i), de_wiener(j,i),de_l2(j,i),de_kernel(j,i)])~=de_l1(j,i)
            flag=0;
        end
    end
    if(flag==1)
        disp(i);
    end
end

index=10;
plot_cureve=[refl_test(index,:);refl_pre_l1(:,index)';refl_pre_pinv(:,index)';refl_wiener_pinv(:,index)';refl_pre_l2(:,index)';refl_pre_kernel(:,index)'];
csvwrite([num2str(index),'.csv'],plot_cureve);
de_table=[[de_l1(:,index) de_pinv(:,index) de_wiener(:,index) de_l2(:,index) de_kernel(:,index)];[de_rms_l1(index) de_rms_pinv(index)  ...
de_rms_wiener(index) de_rms_l2(index) de_rms_kernel(index)...    
]]
csvwrite([num2str(index),'_table.csv'],de_table);


% figure;
% index=185;
% plot(400:10:700,refl_test(index,:));
% hold on;
% plot(400:10:700,refl_pre_l1(:,index));
% plot(400:10:700,refl_pre_pinv(:,index));
% plot(400:10:700,refl_wiener_pinv(:,index));
% ylabel('Reflectance');
% xlabel('Wavelenth/nm');
% legend('benchmark','Proposed','Pseudo-Inverse','Wiener')
% de_l1(:,index)
% de_pinv(:,index)
% de_wiener(:,index)
% de_rms_l1(index)
% de_rms_pinv(index)
% de_rms_wiener(index)
% 
% A=[400:10:700;refl_test(index,:);refl_pre_l1(:,index)';refl_pre_pinv(:,index)';refl_wiener_pinv(:,index)']