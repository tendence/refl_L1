categories ={'nylon','paper','cotton','poly'};


xde_d651=[];
xde_d652=[];
resp=[];
refl=[];
for i=1:size(categories,2)
    category=categories{i};
    resp_tmp=load([category,'_resp.txt']);
    refl_tmp=load([category,'.txt']);
    resp=[resp;resp_tmp];
    refl=[refl;refl_tmp];

end



d65_l1=[];
d65_ps=[];
d65_wiener=[];
%for train_num=[20:1:30,40:10:90,100:100:size(resp,1)]
for train_num=20:10:160  
    xde_d651=[];
    xde_d652=[];
    xde_d653=[];
    for loop=1:20
        index_ran=randperm(size(resp,1));
        resp_t=resp(index_ran(1:train_num),:);
        refl_t=refl(index_ran(1:train_num),:);
        indices = crossvalind('Kfold',size(resp_t,1),10);
        for j=1:10
            test=(indices==j);
            train=~test;
            refl_test_p=func_l1_ref_rec(resp_t(train,:),refl_t(train,:),resp_t(test,:));
            de_d651 = func_batch_cmcde21(refl_t(test,:)', refl_test_p, 'd65_64');
            refl_test_p=func_pinv_ref_rec(resp_t(train,:),refl_t(train,:),resp_t(test,:));
            de_d652 = func_batch_cmcde21(refl_t(test,:)', refl_test_p, 'd65_64');
            refl_test_p=func_wiener_ref_rec(resp_t(train,:),refl_t(train,:),resp_t(test,:));
            de_d653 = func_batch_cmcde21(refl_t(test,:)', refl_test_p, 'd65_64');
            %msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), std(de_d65), max(de_d65));
            %disp(msg_de_d65)
            xde_d651=[xde_d651;[mean(de_d651),median(de_d651),max(de_d651)]];
            xde_d652=[xde_d652;[mean(de_d652),median(de_d652),max(de_d652)]];
            xde_d653=[xde_d653;[mean(de_d653),median(de_d653),max(de_d653)]];
        end
    end
    d65_l1=[d65_l1;mean(xde_d651)];
    d65_ps=[d65_ps;mean(xde_d652)];
    d65_wiener=[d65_wiener;mean(xde_d653)];
    disp(train_num)
end
save('d65.mat','d65_l1','d65_ps','d65_wiener')

figure;
%plot([20:1:30,40:10:90,100:100:size(resp,1)],d65_l1(:,2))
plot([20:10:160 ],d65_l1(:,1))
hold on;
plot([20:10:160 ],d65_ps(:,1))
plot([20:10:160 ],d65_wiener(:,1))
xlabel('traning samples')
ylabel('color deference mean with D65')
legend('L1','Pseudo')

figure;
%plot([20:1:30,40:10:90,100:100:size(resp,1)],d65_l1(:,2))
plot([20:10:160 ],d65_l1(:,2))
hold on;
plot([20:10:160 ],d65_ps(:,2))
plot([20:10:160 ],d65_wiener(:,3))
xlabel('traning samples')
ylabel('color deference standard deviation with D65')
legend('L1','Pseudo','Wiener')

figure;
%plot([20:1:30,40:10:90,100:100:size(resp,1)],d65_l1(:,2))
plot([20:10:160 ],d65_l1(:,3))
hold on;
plot([20:10:160 ],d65_ps(:,3))
plot([20:10:160 ],d65_wiener(:,3))
xlabel('traning samples')
ylabel(' maxmum color deference with D65')
legend('L1','Pseudo','Wiener')


categories ={'nylon','paper','cotton','poly'};



category=categories{4}
refl=load([category,'.txt']);
figure;
plot(400:10:700,refl');
ylabel('Reflectance');
xlabel('Wavelenth/nm');
title('polyester')




