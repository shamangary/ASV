function [] = plotMatches( matches,im1,im2,f1,f2 )
%PLOTMATCHES Summary of this function goes here
%   Detailed explanation goes here

if size(im1,3) > 1
    im1 = rgb2gray(im1);
end
if size(im2,3) > 1
    im2 = rgb2gray(im2);
end

numMatches = size(matches,2);

dh1 = max(size(im2,1)-size(im1,1),0) ;
dh2 = max(size(im1,1)-size(im2,1),0) ;

        


if size(matches,2)>0
            

    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;  
    colormap('gray');
    o = size(im1,2) ;
    if size(matches,2)>0
        line([f1(1,matches(1,:));f2(1,matches(2,:))+o], [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
    end
    hold on
    title(sprintf('%d tentative matches', numMatches),'FontSize',30) ;
    axis image off ;        
end




end

