refl_paper=load(['paper','.txt']);
refl_cotton=load('cotton.txt');
refl_poly=load('poly.txt');
refl_nylon=load('nylon.txt');

refl_total =[refl_paper;refl_cotton;refl_poly;refl_nylon];
xyz_total=zeros(816,3);
for i=1:size(refl_total,1)
    xyz_total(i,:)=r2xyz(refl_total(i,:),400,700,'d65_64');
    
end
rgb_total=xyz2rgb(xyz_total/100);

p = 0.7;      % proportion of rows to select for training
N = size(refl_total,1);  % total number of rows 
tf = false(N,1);    % create logical index vector
tf(1:round(p*N)) = true ;    
tf = tf(randperm(N)) ;  % randomise order
rgb_train=rgb_total(tf,:);
refl_train=refl_total(tf,:);
rgb_test=rgb_total(~tf,:);
refl_test=refl_total(~tf,:);

%polynominal methods [R G B R^2 B^2 G^2 RG RB GB] to refl
rgb_train_ex=[rgb_train,rgb_train.*rgb_train,rgb_train(:,1).*rgb_train(:,2),rgb_train(:,1).*rgb_train(:,3),rgb_train(:,2).*rgb_train(:,3)];
rgb_test_ex=[rgb_test,rgb_test.*rgb_test,rgb_test(:,1).*rgb_test(:,2),rgb_test(:,1).*rgb_test(:,3),rgb_test(:,2).*rgb_test(:,3)];
refl_pre=func_pinv_ref_rec(rgb_train_ex,refl_train,rgb_test_ex);
de =func_batch_cmcde21(refl_test', refl_pre, 'f2_64');
mean(de)
% GP method
refl_pre_gp=func_gp_ref_rec(rgb_train,refl_train,rgb_test,0.001);
de =func_batch_cmcde21(refl_test', refl_pre_gp, 'f2_64');
mean(de)

%RBF method
net=newrbe(rgb_train',refl_train',45);
refl_pred=sim(net,rgb_test');
de =func_batch_cmcde21(refl_test', refl_pred, 'f2_64');
mean(de)

