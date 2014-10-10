function [X]=matchPairs(X1,F1,X2,F2)
x1=X1(:,1);
y1=X1(:,2);

x2=X2(:,1);
y2=X2(:,2);

L1=length(x1);
L2=length(x2);
X=[];


for i=L1:-1:1
    err=[];
    Index=[];
   for j=1:L2
       if(sum(j==Index)==0)
       er=sum(abs(F1(i,:)-F2(j,:)))/128;
       err=[err;er];
       else
           break;
       end
   end
   [MinIndex index]=min(err);
if(sqrt((x1(i)-x2(index))^2+(y1(i)-y2(index))^2)<200)
   X=[X; x1(i) y1(i) x2(index) y2(index)];
   Index=[Index; index];
end
 end

end