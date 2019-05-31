%PCA

file_name='poly.txt';

file_name2='paper.txt';

data=load(file_name);

data2=load(file_name2);

[coeff]=pca(data);
[coeff2]=pca(data2);
for i=1:5
    figure;
    plot(coeff(:,i));
    hold on;
    plot(coeff2(:,i));
end

categories ={'nylon','paper','cotton','poly'};
number_main_vector=5;
main_vectors=[];
for i=1:size(categories,2)    
    category=categories{i};
    refl=load([category,'.txt']);
    coeff=pca(refl);
    main_vector=coeff(:,1:number_main_vector);
    main_vectors=[main_vectors; main_vector];
end

for i=1:number_main_vector
    figure;
    main_vector=main_vectors(:,i);
    main_vector=reshape(main_vector,[],size(categories,2) );
    plot(400:10:700,main_vector);
    xlabel('wavelength(mm)');
    ylabel('reflectance(%)')
    legend(categories{1},categories{2},categories{3},categories{4});
   % title(['the ',num2str(i),'th  vector']);
   csvwrite(['the ',num2str(i),'th  vector.csv'],main_vector)
end

figure;
resp=load('cotton_resp.txt');
refl=load('cotton.txt');
plot(400:20:700,resp(10,:)*100)
csvwrite('sample_resp.csv',resp(10,:)*100);
hold on;plot(400:10:700,refl(10,:)*100)
csvwrite('sample_refl.csv',refl(10,:)*100);
legend('response','reflectance')
%axis('nm','reflectance')
xlim([400 700]);
xlabel('wavelength(mm)');
ylabel('reflectance(%)')
title('cotton sample #10')