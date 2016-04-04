% ASV Demo Code 
% Version: 1 (2016/3/11)
% 
% 
% All rights reserved.
% -----------------------------------------------------------------------------------------------
% Code author: Tsun-Yi Yang 
% Email: shamangary@hotmail.com
% Project page: http://shamangary.logdown.com/posts/587520
% Paper: [CVPR16] Accumulated Stability Voting: A Robust Descriptor from Descriptors of Multiple Scales
% 
% If you use the code, please cite the paper.
% If any bug is found, please email me.
% You may use the code for academic study.
% However, using the provided code for commercial purpose is forbidden.
% -----------------------------------------------------------------------------------------------
% Tested platform:
% Ubuntu 12.04 LTS (I do not test the code on Windows or Mac.)
% Matlab R2012b
% 
% -----------------------------------------------------------------------------------------------

function [ AP,P_set,R_set,tol_correct ] = TYY_AP( Affmatches,matches,dis)

amax = max(Affmatches(1,:));
tol_correct = size(intersect(Affmatches(1,:),1:amax),2);
P_set = [];
R_set = [];
AP = 0;

D = max(dis)-min(dis);
r_th = min(dis):(D/30):max(dis);

matches_LD = sort(L2D(matches,Affmatches),2);
if size(matches_LD>0)
    id_good = double(matches_LD(:,1) == 0);
    
    fprintf('total correct matches: %d\n',sum(id_good));
    for r_num = 1:size(r_th,2)
        
        find_id = dis<=r_th(r_num);
        correct = sum(id_good(find_id));
        if sum(find_id>0) >0 && tol_correct >0
            P = correct/sum(find_id>0);
            R = correct/tol_correct;
        else
            P = 0;
            R = 0;
        end
        P_set = [P_set,P];
        R_set = [R_set,R];
        
    end
end

id = find((P_set+R_set)>0);
if size(id,2) > 0
    P_set = P_set(id);
    R_set = R_set(id);
    P_set = [P_set(1),P_set];
    R_set = [0,R_set];
    for m = 1:size(P_set,2)-1
        AP = AP  + (P_set(m)+P_set(m+1))/2*(R_set(m+1)-R_set(m));
    end
else
    P_set = 0;
    R_set = 0;
    AP = AP  + 0 ;
end


end

