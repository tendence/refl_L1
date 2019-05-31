clear;
    
load weights;
clear a_31 c_31 c_64 d50_31 d50_64 d55_31 d55_64 d65_31  % clear unuseful ill/obs condition
clear d75_31 d75_64 f2_31 f7_31 f7_64 f11_31 f11_64      % clear unuseful ill/obs condition


%% 读入数据
% refl = load('refl-201312.txt');
% resp = load('resp-201312.txt');
refl = load('nylon.txt');

% channels1=[3,8,13];%3
% channels2=[1,4,8,13,16];%6
% channels5=[1,4,8,10,13,16];%6
% channels6=[1,4,8,10,11,13,16];%6
% channels3=[1,3,5,7,9,11,13,15];%8
% channels4=1:16;%16
channels0=[4,17,25];
channels1=[1,7,13,19,25,31];
channels2=[1,6,11,16,21,26,31];
channels3=[1,4,7,10,13,16,19,22,25,28,31];
channels4=[1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31];

resp=refl(:,channels4);
n = size(refl,1);

% ind_train = 1:round(n/2);
% ind_test = round(n/2)+1:n;
trainingsamples=50
 index = randperm(n);
 ind_train = index(1:trainingsamples);
 ind_test = index(145:n);

% ind_train=1:n;
% ind_test=1:n;

refl_train = refl(ind_train,:); resp_train = resp(ind_train,:);
refl_train = refl_train';  resp_train = resp_train';

refl_test = refl(ind_test,:); resp_test = resp(ind_test,:);
refl_test = refl_test';  resp_test = resp_test';


[points, num_train] = size(refl_train);
[channels,num_test] = size(resp_test);



%% 基于伪逆的反射率重建
lambda=0.5;
tol = 0.001;

% 模式1：常规伪逆
% W = func_pinv_rWu(resp_train,refl_train,tol,'normal');
% refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
% 
% 模式2：加权伪逆（初步测试，在PANTONE色卡下这种模式最佳，但在MUNSELL模拟数据下该模式无优势）
W = func_weighted_pinv_rWu(resp_train,refl_train,tol);

refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];


% lambda_v =[1,0.5,0.25,0.125,0.06,0.03,0.015,0.008,0.004,0.002,0.001,0.00001];
% error=[];
% for k=1:length(lambda_v)
% 	W =func_TV_regu(resp_train,refl_train,lambda_v(k),tol);
%     refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
%     de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
%     error=[error,mean(de_d65)];
% end
% figure;plot(error)
% hold on;
% error=[];
% 
% for k=1:length(lambda_v)
% 	W = func_weighted_pinv_rWu(resp_train,refl_train,tol);
%     refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
%     de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
%     error=[error,mean(de_d65)];
% end
% plot(error)
%% 误差
rms = func_batch_rms(refl_test, refl_test_p);
de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
de_f2 = func_batch_cmcde21(refl_test, refl_test_p, 'f2_64');
msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), std(de_d65), max(de_d65));
msg_de_f2   = sprintf('DE_f2:          [%f    %f    %f]',mean(de_f2), std(de_f2), max(de_f2));
msg_rms     = sprintf('mse:   [%f    %f    %f]',mean(rms), std(rms), max(rms));
strvcat(msg_de_d65, msg_de_f2, msg_rms)

W =func_TV1_regu(resp_train,refl_train,lambda,tol);
refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
rms = func_batch_rms(refl_test, refl_test_p);
de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
de_f2 = func_batch_cmcde21(refl_test, refl_test_p, 'f2_64');
msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), std(de_d65), max(de_d65));
msg_de_f2   = sprintf('DE_f2:          [%f    %f    %f]',mean(de_f2), std(de_f2), max(de_f2));
msg_rms     = sprintf('mse:   [%f    %f    %f]',mean(rms), std(rms), max(rms));
strvcat(msg_de_d65, msg_de_f2, msg_rms)

W =func_TV_regu(resp_train,refl_train,lambda,tol);
refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
rms = func_batch_rms(refl_test, refl_test_p);
de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
de_f2 = func_batch_cmcde21(refl_test, refl_test_p, 'f2_64');
msg_de_d65  = sprintf('DE_d65:         [%f    %f    %f]',mean(de_d65), std(de_d65), max(de_d65));
msg_de_f2   = sprintf('DE_f2:          [%f    %f    %f]',mean(de_f2), std(de_f2), max(de_f2));
msg_rms     = sprintf('mse:   [%f    %f    %f]',mean(rms), std(rms), max(rms));
strvcat(msg_de_d65, msg_de_f2, msg_rms)
% 误差
% errorofpsu_v=[];
% errorofTV_v=[];
% for testsample = 40:n
%     errorofpsu=[];
%     errorofTV=[];
%     for exp =1:40
%         index = randperm(n);
%         ind_train = index(1:testsample);
%         ind_test = index(testsample+1:n);
% 
%         refl_train = refl(ind_train,:); resp_train = resp(ind_train,:);
%         refl_train = refl_train';  resp_train = resp_train';
% 
%         refl_test = refl(ind_test,:); resp_test = resp(ind_test,:);
%         refl_test = refl_test';  resp_test = resp_test';
%         
%         W = func_weighted_pinv_rWu(resp_train,refl_train,tol);
%         refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
%         de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
%         errorofpsu=[errorofpsu,mean(de_d65)];
%         
%         W =func_TV_regu(resp_train,refl_train,0.03,tol);
%         refl_test_p = W * [resp_test; ones(1,size(resp_test,2))];
%         de_d65 = func_batch_cmcde21(refl_test, refl_test_p, 'd65_64');
%         errorofTV=[errorofTV,mean(de_d65)];
%     end
%     errorofTV_v=[errorofTV_v,mean(errorofTV)];
%     errorofpsu_v=[errorofpsu_v,mean(errorofpsu)];
%     disp(testsample-40);
% end
% plot(errorofTV_v);
% hold on;
% plot(errorofpsu_v);

