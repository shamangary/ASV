clear all
close all
clc
%% Library and paths
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = './Oxford_dataset/';
Lname = {'bark','bikes','boat','graf','leuven','trees','ubc','wall'};
detectType = 1;
%% Extract the descriptor from the whole dataset
F = 0;
T = 0;
for i = 1:8
    for j = 1:6
        tic
        fprintf('i:%d  j:%d\n',i,j)
        im1 = imread([dataset_dir,Lname{i},'/img',num2str(j),'.ppm']);
        
        
        
        if size(im1,3)>1
            im1 = rgb2gray(im1);
        end
        if detectType == 1
            [f,d_sift] = extract(im1,'sift');
            % Remove same position points
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
        
        if detectType == 1
            nameF = ['./imageFD/DoG/',num2str(i),'/',num2str(j)];
        end
        if size(dir(nameF),1) ==0
            mkdir(nameF)
        end
        
        
        
        save([nameF,'/SIFT'],'f','d_sift')
        t = toc;
        fprintf('time cost: %.2f secs\n',t);
        T = T+t;
        F = F+ size(d_sift,2);
    end
    
    
    
    
    
    
    
end





