function [X] = SIFT_keypoints(Image)
X=[];
if(size(Image,3)==3)
    RGB=Image;
    clear Image
    Image=rgb2gray(RGB);
end
% primitives
a=1;
k0=.5*sqrt(2); sigma=1.6; Dim=[7 7];
% Create image pyramid
Iv=zeros(a*size(Image));
Iv(1:a:end,1:a:end) = Image; % Then I will double

I0 =im2double(Iv);
%I0=Iv;
IXX=I0;
K=[];
k5=0;
% ............. No .1
for octave=1:6
if (octave==1)
k1=(sqrt(2)^(octave-1))*k0;  
k2=k1*sqrt(2);
k3=k2*sqrt(2);
k4=k3*sqrt(2);
k5=k4*sqrt(2);
else
    k1=2*k1;    
    k2=2*k2;
    k3=2*k3;
    k4=2*k4;
    k5=2*k5;
end
G0 = fspecial('gaussian',Dim,k1*sigma);

G1 = fspecial('gaussian',Dim,k2*sigma);

G2 = fspecial('gaussian',Dim,k3*sigma);

G3 = fspecial('gaussian',Dim,k4*sigma);

G4 = fspecial('gaussian',Dim,k5*sigma);

K=[K;k1 k2 k3 k4 k5];

I00 = conv2(IXX,G0,'same');
I11 = conv2(IXX,G1,'same');
I22 = conv2(IXX,G2,'same');
I33 = conv2(IXX,G3,'same');
I44 = conv2(IXX,G4,'same');

% Create DOG 
DoG{1}=(I11-I00);
DoG{2}=(I22-I11);
DoG{3}=(I33-I22);
DoG{4}=(I44-I33);


for scale=2:3
       r=0;
    for y=3:size(IXX,1)-2
       for x=3:size(IXX,2)-2
           if(DoG{scale}(y,x)~=0)
              Level_2=DoG{scale}(y-1:y+1,x-1:x+1);
          Level_1_max=max(max(DoG{scale-1}(y-1:y+1,x-1:x+1))); 
          Level_1_min=min(min(DoG{scale-1}(y-1:y+1,x-1:x+1))); 
          
          Level_2_max=max(max(DoG{scale}(y-1:y+1,x-1:x+1)));
          Level_2_min=max(max(DoG{scale}(y-1:y+1,x-1:x+1)));
          
          Level_3_max=max(max(DoG{scale+1}(y-1:y+1,x-1:x+1)));
          Level_3_min=min(min(DoG{scale+1}(y-1:y+1,x-1:x+1)));
          analyzingPoint=Level_2(2,2);
         
       
          
          %
    Dxx=Level_2(3,3)+Level_2(1,3)-2*Level_2(2,3);
   Dyy=Level_2(3,3)+Level_2(3,1)-2*Level_2(3,2);
   Dxy=Level_2(3,3)-Level_2(2,3)-Level_2(3,1)+Level_2(2,2);
   thresh=(Dxx+Dyy)^2/(Dxx*Dyy-Dxy^2);
   
          if(( analyzingPoint>Level_2_max && analyzingPoint>Level_3_max) || ...
                  ( analyzingPoint<Level_1_min && analyzingPoint<Level_3_min))
  r=r+1;
            if(abs(thresh)>=10)
          X=[X;(2^(octave-1))*y (2^(octave-1))*x 1.2*scale*sigma*octave]; 
            end
          end
          %
           end
       end
    end
%    fprintf('octave:%d , scale: %d , repeatability: %d\n',octave,scale,r);
end


clear IXX;
IXX = impyramid(I0, 'reduce');
clear I0, DoG;
I0=IXX;

end % end of octaves

K



end