% Scale Invariant Feature Transform by David Lowe
% Implemented by Davood Falahati
% This is the matlab version and I will write it in openCV as well.
% I have two images, say, I_left and I_right
% I prepared a function that takes care of SIFT keypoint detection
% I call it: function [X] = SIFT_keypoints(image)
clear all, close all, clc;

for x=-20:20
    for y=-20:20
        I(x+21,y+21)=sqrt(x^2+y^2);
    end
    
end
% I=fspecial('gaussian', [25 25], 4);
% surf(I)
% shg
 I_left=(imread('frame_left.png'));
%  I_left=imresize(imread('s1.png'),scale);
%  I_left=imresize(imread('cameraman.tif'),1.5);
%  imshow(I_left,[]);

[X_left, I_out2]=SIFT_keypoints3(I_left);
[Orientation X_left or1]=SIFT_descriptors(I_out2,X_left);
imshow(I_left)
drawCircle(X_left(:,2),X_left(:,1),4*X_left(:,3),(Orientation-1)*10,'white');
 I_right=imread('frame_right.png');
%  I_right=(imresize(imread('cameraman.tif'),1));
%   I_right=imrotate(imread('frame_left.png'),60);
   [X_right, I_out]=SIFT_keypoints3(I_right);
%  size(X_right)
 [Orientation2 X_right or2]=SIFT_descriptors(I_out,X_right);
subplot(1,2,2)
imshow(I_right)
 drawCircle(X_right(:,2),X_right(:,1),4*X_right(:,3),(Orientation2-1)*10,'yellow');
Matches=matchPairs(X_left,or1,X_right,or2);
Set1=Matches(:,1:2);
Set2=Matches(:,3:4);
 t = cp2tform(Set1, Set2, 'affine');
 XX=[Set2 ones(size(Set2,1),1)]*t.tdata.T;
 
showFusedMatches(I_left,I_right,Matches);
% Finding A matrix
% A is a 2x9 Matrix
H=zeros(3);
for i=1:4:size(Set1,1)/4
x1=[Set1(i,1:2) 1];
x2=[Set1(i+1,1:2) 1];
x3=[Set1(i+2,1:2) 1];
x4=[Set1(i+3,1:2) 1];
x1p=[Set2(i,1:2) 1];
x2p=[Set2(i+1,1:2) 1];
x3p=[Set2(i+2,1:2) 1];
x4p=[Set2(i+3,1:2) 1];
A=[0 0 0 -x1 x1p(2)*x1];
A=[A;x1 0 0 0 -x1p(1)*x1];
A=[A;0 0 0 -x2 x2p(2)*x2];
A=[A;x2 0 0 0 -x2p(1)*x2];

A=[A;0 0 0 -x3 x3p(2)*x3];
A=[A;x3 0 0 0 -x3p(1)*x3];

A=[A;0 0 0 -x4 x4p(2)*x4];
A=[A;x4 0 0 0 -x4p(1)*x4];
[U S V]=svd(A);
H=[V(1:3,end)' ; V(4:6,end)' ; V(7:9,end)'];
H=H/V(9,end);
end
H
S=[Set2 ones(size(Set1),1)];
XY=[];
for i=1:size(Set1,1)
    nn=H*S(i,:)';
    nn=nn/(nn(3));
XY=[XY; nn'];

end
 shg