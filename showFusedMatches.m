function [varargout] = showFusedMatches(I1,I2,Matches)
figure,
I=[I1 I2];
imshow(I,[]);
hold on

for i=1:size(Matches,1)
%  [Matches(i,1:2) Matches(i,3)  Matches(i,4)]


  
% text(Matches(i,1),Matches(i,2),'x','Color','yellow')
% text(Matches(i,3),Matches(i,4),'y','Color','white');
plot([Matches(i,2) Matches(i,4)+size(I1,2)],[Matches(i,1) Matches(i,3)],'yellow','LineWidth',1);
end

shg
end