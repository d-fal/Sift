%
function [X,varargout]=SIFT_descriptors(Image,KeyPoints)
[H W]=size(Image);

for j=2:H-1
    for i=2:W-1
Gradient(j,i)=sqrt((Image(j,i+1)-Image(j,i-1))^2+(Image(j+1,i)-Image(j-1,i))^2);
tmp=atan2(Image(j+1,i)-Image(j-1,i),Image(j,i+1)-Image(j,i-1))*180/pi;
if sign(tmp)==-1
Orientation(j,i)=359+tmp;
else
Orientation(j,i)=tmp;    
end

    end
end

C=zeros(5,5);
for i=-2:2
    for j=-2:2
        if(i^2+j^2<=5)
        C(i+3,j+3)=exp(-((i)^2+(j)^2));
        end
    end
end
C=C/sum(sum(C));

Y1=KeyPoints(:,1);
X1=KeyPoints(:,2);
Or_vector=[];
proper_OrientationVector=[];
properKeyPoints=[];

for i=1:size(KeyPoints,1)
    x=X1(i);
    y=Y1(i);
    if (x>2 && x<W-2 && y>2 && y<H-2)
        if (x>8 && x<W-8 && y>8 && y<H-8)
 properKeyPoints=[properKeyPoints;KeyPoints(i,:)];
 properOrientation=Orientation(y-8:y+8,x-8:x+8);
 properGradient=Gradient(y-8:y+8,x-8:x+8);
 
        else 
            continue;
        end
G=Gradient(y-2:y+2,x-2:x+2).*C;
O=Orientation(y-2:y+2,x-2:x+2);
    else 
        continue;
    end
[m n]=size(G);
Or1=zeros(1,36);

for j=1:m
    for i=1:n
Or1(floor(Orientation(y,x)/10)+1)=Or1(floor(Orientation(y,x)/10)+1)+1;
    end
end

[m n]=size(properGradient);
Or2Vec=[];  
for z=1:4
    for w=1:4
Or2=zeros(1,8); 
  
for j=1:m/4
    for i=1:n/4
Or2(floor(properOrientation(4*(z-1)+j,4*(w-1)+i)/45)+1)=Or2(floor(properOrientation(4*(z-1)+j,4*(w-1)+i)/45)+1)...
    +abs(properGradient(4*(z-1)+j,4*(w-1)+i));
    end
end

 Or2Vec=[Or2Vec Or2];

end
end
proper_OrientationVector=[proper_OrientationVector; Or2Vec];

    [mx mxl]=max(Or1);
   
    Or_vector=[Or_vector; mxl];
   
    
    
end





X=Or_vector;
if(nargout==2)
varargout{1}=properKeyPoints;
else if (nargout==3)
        varargout{1}=properKeyPoints;
        varargout{2}=proper_OrientationVector;
    end
end
end