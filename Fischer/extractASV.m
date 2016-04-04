clear all
close all
clc

%% Library and paths
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = './Fischer_dataset/';
Lname = {'01_graffity','02_autumn_trees','03_freiburg_center','04_freiburg_from_munster_crop','05_freiburg_innenstadt','09_cool_car','12_wall','13_mountains','14_park_crop','17_freiburg_munster','18_graffity','20_hall2','21_dog2','22_small_palace','23_cat1','24_cat2'};
detectType = 1;
%% Important parameters

isInter = 0; % Default 0. If you set to 1 then the interpolation will be activated.
des = 'sift'; % There are three type descriptor in vlfeat covdet. You can choose 'sift', 'liop', or 'patch'.
opt.sc_min = 1/6; % The smallest size.
opt.sc_max = 3; % The biggest size.
opt.ns = 10; % Number of the sampled scales.

%% (Optional, usually you don't want to change these.)
% The following parameters belongs to the extended version of ASV.
% While scale space is studied in the original setting,
% rotation might also help to improve the performace.
% We do not change any of the rotation parameters for convience,
% but you are free to try these. The performance will be further improved.
opt.rc_min = 0; % The smallest angle.
opt.rc_max = 0; % The biggest angle.
opt.nr = 1; % Number of the sampled angles.


%% Extract the descriptor from the whole dataset
for i =1:16
    LL = dir([dataset_dir,Lname{i},'/*.jpg']);
    LLname = {LL.name};
    for j = 1:size(LLname,2)
        fprintf('i:%d  j:%d\n',i,j)
        im1 = imread(['./Fischer_dataset/',Lname{i},'/',LLname{j}]);

        if size(im1,3)>1
            im1 = rgb2gray(im1);
        end
        if detectType == 1
            %% Initialize the detected frame for fair comparison
            [f,d_sift] = extract(im1,'sift'); % always use sift as standard
            %% Remove same position points
            id_used = [1];
            for f_i = 1:size(f,2)
                temp = f(:,f_i)';
                line = [temp(1:2)];
                if f_i>1 && norm(tempLine(1:2)-line(1:2)) ~= 0
                    id_used = [id_used,f_i];
                end
                tempLine = line;
            end
            
            f = f(:,id_used);
            d_sift = d_sift(:,id_used);         

        

        end
        

        %% ASV(1S): median thresholding
        d_asv = vl_asvcovdet(im1, opt, f, des, isInter);

        
        %% Save
        if detectType == 1
            nameF = ['./imageFD/DoG/',num2str(i),'/',num2str(j)];
        end
        if size(dir(nameF),1) ==0
            mkdir(nameF)
        end


        save([nameF,'/ASV'],'f','d_asv','opt')

    end
    

    
    
    
    
    
end





