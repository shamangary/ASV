clear all
close all
clc
%% Library and paths
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = './Oxford_dataset/';
Lname = {'bark','bikes','boat','graf','leuven','trees','ubc','wall'};
detectType = 1;
%% Important Parameters

opt.sc_min = 1/6; % The smallest size.
opt.sc_max = 3; % The biggest size.
opt.ns = 10; % Number of the sampled scales.

%% Extract the descriptor from the whole dataset
F = 0;
T= 0;
for i = 1:8
    for j = 1:6
        tic
        fprintf('i:%d  j:%d\n',i,j)
        im1 = imread([dataset_dir,Lname{i},'/img',num2str(j),'.ppm']);


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
        
        %% DSP
        [f_dsp, d_dsp] = vl_dspcovsift(im1, opt, f);
        d_dsp = double(d_dsp);

        %% Save
        if detectType == 1
            nameF = ['./imageFD/DoG/',num2str(i),'/',num2str(j)];
        elseif detectType == 2
            nameF = ['./imageFD/MSER/',num2str(i),'/',num2str(j)];
        end
        if size(dir(nameF),1) ==0
            mkdir(nameF)
        end


        save([nameF,'/DSP'],'f','d_dsp','opt')
        t = toc;
        fprintf('time cost: %.2f secs\n',t);
        T = T+t;
        F = F+ size(d_sift,2);
    end
    

    
    
    
    
    
end





