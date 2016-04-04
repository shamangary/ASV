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

close all
clear all
clc
%% Parameters you may control
desType = 1; % Set to 1 for SIFT, 2 for DSP, 3 for ASV-SIFT(1S), 4 for ASV-SIFT(1M2M).
detectType = 1; % 1 for DoGAff of vlfeat covdet function with affine approximation
samMax = 5000; % Default 5000 keypoints (already sorted by peakscores in extraction)
isPlot = 1; % Set to 1 and the PR-curve will show.
isSave = 1; % Set to 1 and the results will be saved.



%% Setting Paths, Vlfeat Library, and Vlfeat Benchmark Library
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = '/home/shamangary2/Desktop/codeDemo/image_matching_dataset/Fischer/Fischer_dataset/';
Lname = {'01_graffity','02_autumn_trees','03_freiburg_center','04_freiburg_from_munster_crop','05_freiburg_innenstadt','09_cool_car','12_wall','13_mountains','14_park_crop','17_freiburg_munster','18_graffity','20_hall2','21_dog2','22_small_palace','23_cat1','24_cat2'};
LT = dir(['./Fischer_dataset/transformations/*.mat']);
LTname = {LT.name};
import benchmarks.*;
addpath('./Fischer_dataset/code/')


%%
AP = zeros(1,16*25);
for i =1:16
    LL = dir([dataset_dir,Lname{i},'/*.jpg']);
    LLname = {LL.name};
    for j = 2:26
        tic
        fprintf('i:%d  j:%d\n',i,j);

        im1 = imread(['./Fischer_dataset/',Lname{i},'/',LLname{1}]);
        im2 = imread(['./Fischer_dataset/',Lname{i},'/',LLname{j}]);

        
        
        if detectType == 1
            nameD1 = ['./imageFD/DoG/',num2str(i),'/',num2str(1)];
            nameD2 = ['./imageFD/DoG/',num2str(i),'/',num2str(j)];
        else
            fprintf('Wrong "detectType" choice!!! Error!!!\n');
            stop
        end
        
        %% Different Descriptor Choices
        if desType == 1
            load([nameD1,'/SIFT']);
            f1 = f;
            d1 = d_sift;
            
            load([nameD2,'/SIFT']);
            f2 = f;
            d2 = d_sift;
        elseif desType == 2
            load([nameD1,'/DSP']);
            f1 = f;
            d1 = d_dsp;
            
            load([nameD2,'/DSP']);
            f2 = f;
            d2 = d_dsp;
        elseif desType == 3
            load([nameD1,'/ASV']);
            f1 = f;
            d1 = d_asv;
            
            load([nameD2,'/ASV']);
            f2 = f;
            d2 = d_asv;
        elseif desType == 4
            load([nameD1,'/1M2M']);
            f1 = f;
            d1 = d_1m2m;
            
            load([nameD2,'/1M2M']);
            f2 = f;
            d2 = d_1m2m;
        else
            fprintf('Wrong "desType" choice!!! Error!!!\n');
            stop
        end
        
        
        
        %% Choose the maximum number of the keypoints
        
        if size(d1,2)>samMax
            T = d1(:,1:samMax);
        else
            T = d1;
        end
        if size(d2,2)>samMax
            S = d2(:,1:samMax);
        else
            S = d2;
        end
        
        fT = f1(:,1:size(T,2));
        fS = f2(:,1:size(S,2));
        
        %% Ellipse Overlap
        
        fT_old = fT;
        fS_old = fS;
        load(['./Fischer_dataset/transformations/',LTname{j-1}]);
        
        invert = 0;
        if j == 10 || j== 11 || j == 12
            invert = 1;
        end
        for ft = 1:size(fT,2)
            X = fT(1,ft);
            Y = fT(2,ft);
            coor = [Y,X];
            %f_temp = [[reshape(fT(3:6,ft),2,2),[0;0]];0 0 1];
            
            A1to2 = getAff(X,Y,transTForm,size(im2),invert);
            YXat2 = applyTransformationToCoords(transTForm, size(im2), coor, invert);
            %fT(:,ft) = tempfT([7 8 1 2 4 5])';
            XYat2 = flipud((YXat2)');
            XY1to2 = flipud((YXat2-coor)');
            H1to2 = [[A1to2,XY1to2];[0 0 1]];
            
            
            tempfT = [[A1to2*reshape(fT(3:6,ft),2,2),XYat2];0 0 1];
            %tempfT = H1to2*[[reshape(fT(3:6,ft),2,2),[fT(1,ft);fT(2,ft)]];0 0 1];
            fT(:,ft) = tempfT([7 8 1 2 4 5])';
        end
        
        goodID = find(all(~isnan(fT),1));
        fT = fT(:,goodID);
        
        %         fT( :, all( isnan( fT ), 1 ) ) = []; % and columns
        %         fT_old( :, all( isnan( fT ), 1 ) ) = []; % and columns
        
        
        
        result = fastEllipseOverlap(fS, fT);
        RN = result.neighs;
        RS = result.scores;
        Affmatches = [];
        %         matches_RS = [];
        for rn = 1:size(goodID,2)
            tempRN = [RN{rn}];
            %             tempRS = [RS{rn}];
            if size(tempRN,2)>0
                for p = 1:size([RN{rn}],2)
                    Affmatches = [Affmatches,[goodID(rn);tempRN(p)]];
                    %                     matches_RS = [matches_RS,tempRS(p)];
                end
            end
        end

        
        %% L2 distance or ratio test        
        LD = L2D(T,S);
        [a_des,b_des] = sort(LD,2);
        matches = [1:size(T,2);b_des(:,1)'];
        
        dist = a_des(:,1); % Euclidean distance
        % dist = a_des(:,1)./a_des(:,2); % ratio test
        
        [AP_temp,P_set,R_set,tol_correct] = TYY_AP(Affmatches,matches,dist);
        
        AP(25*(i-1)+(j-1)) = AP_temp;
        
        if isPlot == 1
            figure(2)
            subplot(2,2,1)
            imshow(im1)
            title('im1:T','FontSize',20)
            subplot(2,2,2)
            imshow(im2)
            title('im2:S','FontSize',20)
            subplot(2,2,3)
            plot(R_set,P_set,'-ro')
            title('PR curve','FontSize',20)
            xlabel('recall','FontSize',20)
            ylabel('precision','FontSize',20)
            subplot(2,2,4)
            bar([tol_correct])
            ylabel('num of correct matches','FontSize',20)
        end
        fprintf('------------------------------------------------------\n');
        fprintf('Average Precision: %.4f\n',AP_temp);
        fprintf('------------------------------------------------------\n');
    end
    
end

%% Save the Results

if isSave == 1
    if detectType == 1
        nameR = ['./mAPdes/DoG/'];
    end
    if size(dir(nameR),1) ==0
        mkdir(nameR)
    end
    if desType == 1
        save([nameR,'allResults_sift'],'AP');
    elseif desType ==2
        save([nameR,'allResults_dsp'],'AP');
    elseif desType ==3
        save([nameR,'allResults_asv'],'AP');
    elseif desType ==4
        save([nameR,'allResults_1m2m'],'AP');
    else
        fprintf('Wrong "desType" choice!!! Error!!!\n');
        stop
    end
end

