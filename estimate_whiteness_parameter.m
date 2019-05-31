function [alpha,beta]=estimate_whiteness_parameter(uv100,uv0,datacolor,lambda)
iter_num=100000;

[~,Dim]=size(uv0);
alpha=0.5*ones(Dim,1);
beta=0.5*ones(Dim,1);
tmp=eye(Dim-1);
D=[tmp zeros(Dim-1,1)]+[zeros(Dim-1,1),-1*tmp];
DTD=D'*D;
R3xR1=sum(uv0.*datacolor);
R3xR2=sum(uv100.*datacolor);
R2xR1=sum(uv0.*uv100);
R1xR1=sum(uv0.*uv0);
R2xR2=sum(uv100.*uv100);
%nxlambdaxDTD=sum(lambda*DTD);
for i=1:iter_num
   %alpha=(R3xR1'-beta.*R2xR1')./(nxlambdaxDTD'+R1xR1');
   %beta=(R3xR2'-alpha.*R2xR1')./(nxlambdaxDTD'+R2xR2');
   alpha=inv(diag(R1xR1')+lambda*DTD)*(R3xR1'-beta.*R2xR1');
   beta=inv(diag(R2xR2')+lambda*DTD)*(R3xR2'-alpha.*R2xR1');
end

