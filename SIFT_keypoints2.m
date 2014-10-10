function [X] = SIFT_keypoints2(a)
X=[];
[m,n,plane]=size(a);
if plane==3
a=rgb2gray(a);
end
a=im2double(a);
original=a;
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0;
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1=[store1 c];
end
clear a;
a=imresize(original,1/((k2+1)*2));

%% 2nd Octave generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store2=[store2 c];
end
clear a;
a=imresize(original,1/((k2+1)*2));

%% 3rd octave generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store3=[store3 c];
end
[m,n]=size(original);
fprintf('\nTime taken for Pyramid level generation is :%f\n',toc);

%% Obtaining key point from the image
i1=store1(1:m,1:n)-store1(1:m,n+1:2*n);
i2=store1(1:m,n+1:2*n)-store1(1:m,2*n+1:3*n);
i3=store1(1:m,2*n+1:3*n)-store1(1:m,3*n+1:4*n);
[m,n]=size(i2);
kp=[];
kpl=[];
tic
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>my && i2(i,j)>mz) || (i2(i,j)<miy && i2(i,j)<miz)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
    end
end
fprintf('\nTime taken for finding the key points is :%f\n',toc);

%% Key points plotting on to the image
for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    X=[X; k1 j1 2];
    i2(k1,j1)=1;
end

end