function [X,varargout] = SIFT_keypoints3(Image)
X=[];

G0 = fspecial('gaussian',[9 9],.5);



if(size(Image,3)==3)
    RGB=Image;
    clear Image
    Image=im2double(rgb2gray(RGB));
end
Image = conv2(Image,G0,'same');
original=Image;
I_out=original;
store1=[];
store2=[];
store3=[];

%% 1st octave generation
k2=0; % 

clear c;
for k2=1:3
    store1{k2}=[];
[H,W,plane]=size(Image);
Image(H:H+6,W:W+6)=0;
   
for k1=0:3
    k=sqrt(2);
    sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:H
    for j=1:W
        t=Image(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1{k2}=[store1{k2} c];
end
clear Image;
Image=imresize(original,1/((k2+1)*2));
end % octave
[m n]=size(original);

%% Obtaining key point from the image
for k2=1:1
i1{k2}=store1{1}(1:m,1:n)-store1{1}(1:m,n+1:2*n);
i2{k2}=store1{1}(1:m,n+1:2*n)-store1{1}(1:m,2*n+1:3*n);
i3{k2}=store1{1}(1:m,2*n+1:3*n)-store1{1}(1:m,3*n+1:4*n);
[m,n]=size(i2{k2});
kp=[];
kpl=[];
tic
for i=9:m-9
    for j=9:n-9
        x=i1{k2}(i-1:i+1,j-1:j+1);
        y=i2{k2}(i-1:i+1,j-1:j+1);
        z=i3{k2}(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
   Level_2=i2{k2}(i-1:i+1,j-1:j+1);   
   Dxx=Level_2(3,3)+Level_2(1,3)-2*Level_2(2,3);
   Dyy=Level_2(3,3)+Level_2(3,1)-2*Level_2(3,2);
   Dxy=Level_2(3,3)-Level_2(2,3)-Level_2(3,1)+Level_2(2,2);
   thresh=(Dxx+Dyy)^2/(Dxx*Dyy-Dxy^2);
        
        if ((i2{k2}(i,j)>my  && i2{k2}(i,j)>mz)...
                || ((i2{k2}(i,j)<mix && i2{k2}(i,j)<miy && i2{k2}(i,j)<miz)))
            if (abs(thresh>10))
                I_out(i,j)=1;
            kp=[kp i2{k2}(i,j)];
            kpl=[kpl i j];
            X=[X;i j k2*1.6];
            end
        end
    end
end
fprintf('\nTime taken for finding the key points is :%f\n',toc);

end
%% Key points plotting on to the image
[H W]=size(original);
if(nargout==2)
   varargout{1}=I_out; 
end

end