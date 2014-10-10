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
% imshow(I_left)
% drawCircle(X_left(:,2),X_left(:,1),4*X_left(:,3),(Orientation-1)*10,'white');
 I_right=imread('frame_right.png');
%  I_right=(imresize(imread('cameraman.tif'),1));
%   I_right=imrotate(imread('frame_left.png'),60);
   [X_right, I_out]=SIFT_keypoints3(I_right);
%  size(X_right)
 [Orientation2 X_right or2]=SIFT_descriptors(I_out,X_right);

% imshow(I_right)
%  drawCircle(X_right(:,2),X_right(:,1),4*X_right(:,3),(Orientation2-1)*10,'yellow');
Matches=matchPairs(X_left,or1,X_right,or2);
Set1=Matches(:,1:2);
Set2=Matches(:,3:4);

 t = cp2tform(Set1, Set2, 'affine');
 XX=[Set2 ones(size(Set2,1),1)]*t.tdata.T;
 Matched2=[];
 for i=1:size(XX,1)
%      sum(abs(XX(i,1:2)-Set1(i,:)))
     if (sum(abs(XX(i,1:2)-Set1(i,:)))<50)
         Matched2=[Matched2; Matches(i,:)];
     end
 end
showFusedMatches(I_left,I_right,Matched2);
% Finding A matrix
% A is a 2x9 Matrix

 shg