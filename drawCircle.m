% m: x
% n: y

function [x]=drawCircle(n,m,R,orientation,color)

theta=[0:.1:2*pi];
hold on
for i=1:length(n)-1
    if(length(R)~=1)
       r=R(i); 
    else
        r=R;
    end
xc=r*cos(theta)+n(i);
yc=r*sin(theta)+m(i);

plot(xc,yc,'w','LineWidth',1.8)
% text(n(i),m(i),num2str(i),'FontSize',8,'Color',color);
%text(xc(i),yc(i),num2str(orientation(i)),'Color','white');
x1=[0:.1:r];
y1=sin(orientation(i)*pi/180).*x1;

plot(x1+n(i).*ones(1,length(x1)),y1+m(i).*ones(1,length(x1)),'r','LineWidth',2)
end
hold off
end