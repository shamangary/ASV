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
desType = 4; % Set to 1 for SIFT, 2 for DSP, 3 for ASV-SIFT(1S), 4 for ASV-SIFT(1M2M).
detectType = 1; % 1 for DoGAff of vlfeat covdet function with affine approximation
samMax = 5000; % Default 5000 keypoints (already sorted by peakscores in extraction)
isPlot = 1; % Set to 1 and the PR-curve will show.
isSave = 1; % Set to 1 and the results will be saved.


%% Setting Paths, Vlfeat Library, and Vlfeat Benchmark Library
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = './Oxford_dataset/';
Lname = {'bark','bikes','boat','graf','leuven','trees','ubc','wall'};
import benchmarks.*;
repBenchmark = RepeatabilityBenchmark('Mode','Repeatability');
repBenchmark.Opts.overlapError = 0.5;



%% Evaluation of the whole dataset
AP = zeros(1,8*5);
for i =1:8
    for j = 2:6
        fprintf('i:%d  j:%d\n',i,j);
        im1 = imread([dataset_dir,Lname{i},'/img1.ppm']);
        im2 = imread([dataset_dir,Lname{i},'/img',num2str(j),'.ppm']);
        H1to2 = dlmread([dataset_dir,Lname{i},'/H1to',num2str(j),'p']);
        
        
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
        
        [score numMatches bestMatches reprojFrames visibleFramesA visibleFramesB] = ...
            repBenchmark.testFeatures(H1to2,size(im1),size(im2),fT, fS);
        % The original method "testFeatures" does not output visibleFramesA and visibleFramesB. I rewrite the function to fit our purpose.
        
        id_A = find(visibleFramesA>0);
        id_B = find(visibleFramesB>0);
        matchAFrames = find(bestMatches(1,:)~=0);
        matchBFrames = bestMatches(1,(bestMatches(1,:)~=0));
        Affmatches = [id_A(matchAFrames);id_B(matchBFrames)];
        
        
        %% L2 distance
        
        LD = L2D(T,S);
        [a_des,b_des] = sort(LD,2);
        matches = [1:size(T,2);b_des(:,1)'];
        
        dist = a_des(:,1); % Euclidean distance
        % dist = a_des(:,1)./a_des(:,2); % ratio test
        
        [AP_temp,P_set,R_set,tol_correct] = TYY_AP(Affmatches,matches,dist);
        
        AP(5*(i-1)+(j-1)) = AP_temp;
        
        
        %% Show the results
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

