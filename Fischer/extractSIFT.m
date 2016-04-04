clear all
close all
clc
%% Library and paths
run ../vlfeat-0.9.18/toolbox/vl_setup
dataset_dir = './Fischer_dataset/';
Lname = {'01_graffity','02_autumn_trees','03_freiburg_center','04_freiburg_from_munster_crop','05_freiburg_innenstadt','09_cool_car','12_wall','13_mountains','14_park_crop','17_freiburg_munster','18_graffity','20_hall2','21_dog2','22_small_palace','23_cat1','24_cat2'};

detectType = 1;


%% Extract the descriptor from the whole dataset
for i = 1:size(Lname,2)
    LL = dir([dataset_dir,Lname{i},'/*.jpg']);
    LLname = {LL.name};
    for j = 1:size(LLname,2)
        fprintf('i:%d  j:%d\n',i,j)
        
        im1 = imread(['./Fischer_dataset/',Lname{i},'/',LLname{j}]);
    

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

    end
    

    
    
    
    
    
end





