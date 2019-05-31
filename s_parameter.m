resp_train=load(['cotton','_resp.txt']);
refl_train=load(['cotton','.txt']);

p = 0.7;      % proportion of rows to select for training
N = size(resp_train,1);  % total number of rows 
tf = false(N,1);    % create logical index vector
tf(1:round(p*N)) = true ;    
tf = tf(randperm(N)) ;  % randomise order
dataTraining_resp = resp_train(tf,:) ;
dataTesting_resp = resp_train(~tf,:);

dataTraining_refl = refl_train(tf,:) ;
dataTesting_refl = refl_train(~tf,:);

%1. paprameter of L2
lambda=0.001:0.001:0.3;
error=zeros(3,length(lambda));
illu='d65_64';
for i=1:length(lambda)
            refl_pre_l1=func_l1_ref_rec(dataTraining_resp,dataTraining_refl,dataTesting_resp,lambda(i));
            refl_pre_l2=func_l2_ref_rec(dataTraining_resp,dataTraining_refl,dataTesting_resp,lambda(i));
            refl_pre_gp=func_gp_ref_rec(dataTraining_resp,dataTraining_refl,dataTesting_resp,lambda(i)/100);
            
            de_l1 =func_batch_cmcde21(dataTesting_refl', refl_pre_l1, illu);
            error(1,i)=mean(de_l1);
            de_l2=func_batch_cmcde21(dataTesting_refl', refl_pre_l2, illu);
            error(2,i)=mean(de_l2);
            de_gp =func_batch_cmcde21(dataTesting_refl', refl_pre_gp, illu);
            error(3,i)=mean(de_gp);
end
plot(error');
legend('L1','L2','Kernel');

%2. parameter of L1

csvwrite('error.csv',error)

%3. parameter of GP