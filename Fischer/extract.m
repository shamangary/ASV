function [frame,des] = extract(I,desType,f)

%     I = imread('0.2M.jpg');
%     figure
%     image(I);
    if size(I,3) >1
        grayImg = rgb2gray(im2single(I));
    else
        grayImg = im2single(I);
    end
    if exist('f') == 0
        [frame, des, S]= vl_covdet(grayImg,'descriptor',desType,'Method', 'DoG','EstimateAffineShape',true,'EstimateOrientation', true,'PeakThreshold',0.0001, 'doubleImage', true);       
        %     [frame, sift, S]= vl_covdet(grayImg,'descriptor','patch','Method', 'DoG','EstimateAffineShape',true,'EstimateOrientation', true,'PeakThreshold',0.01,'PatchResolution',5, 'doubleImage', true);
    else
        [frame, des,S]= vl_covdet(grayImg,'frames',f,'descriptor',desType,'EstimateAffineShape',false,'EstimateOrientation', false,'PeakThreshold',0.0001, 'doubleImage', true);
    end
%     if size(frame,2) < DP
%         DP_use = size(frame,2);
%     else
%         DP_use = DP;
%     end

    pS = S.peakScores;
    
    [~,pSortScore] = sort(pS,'descend');
     
    size(frame,2);
    
    des = des(:,pSortScore);
    frame = frame(:,pSortScore);
    if strcmp(desType,'sift') == 1
        des = double(uint8(des*512));
    else
        des = double(des);
    end
    
%     image(I)
%     height =  int32(size(I,1));
%     weight =  int32(size(I,2));
%     h1 = vl_plotframe(frame(:,1:end)) ;        
%     h2 = vl_plotframe(frame(:,1:end)) ;        
%     set(h1,'color','k','linewidth',3) ;        
%     set(h2,'color','y','linewidth',2) ;     
% 
% stop
end



