%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2014-2015, Jingming Dong
% All rights reserved.
%
% This file is part of the DSP-SIFT library.
%
% The DSP-SIFT library is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% The DSP-SIFT library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with the DSP-SIFT library. If not, see <http://www.gnu.org/licenses/>.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% The library uses VLFeat as its building block. The license of the latter
% is attached as required.
%
% Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the README file).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f_out, d_out] = vl_dspcovsift(im, opt, frames)
% vl_dspsift computes DSP-SIFT descriptors around standard SIFT detections.
%
% @params
%   im:     single-typed, grayscale image
%   opt:    option structure
%           opt.sc_min: scale sampling lower limit
%           opt.sc_max: scale sampling upper limit. Scales are sampled from (sc_min * s, sc_max * s) where s is the detected scale
%           opt.ns:     number of scales to sample
%           opt.ubc:    Lowe's normalization variant
%
% @return
%   f_out:  SIFT features. Each column is a four-tuple (x, y, s, o) = (x-coord, y-coord, scale, dominant-orientation)
%   d_out:  DSP-SIFT descriptors.

    % Detection
%     frames = vl_usift(im);
%     [frames,~] = extract(im);
    
    
%     frames = vl_usift(im, 'peakthresh', 5);
    
    % Set number of scales to sample and scale range
    ns = opt.ns;
    sc_min = opt.sc_min;
    sc_max = opt.sc_max;
    
    % Sample scales around detection
    nf = size(frames, 2);
    f = zeros(6, nf, ns);
    cnt_sc = 0;
    for sc = linspace(sc_min, sc_max, ns)
        cnt_sc = cnt_sc + 1;
        f([1 2], :, cnt_sc) = frames([1 2], :);
        f(3:6, :, cnt_sc) = sc * frames(3:6,:);
    end
    
    % Compute un-normalized SIFT at each scales
    f = reshape(f, [6, nf*ns, 1]);
    
    f_size = zeros(1,nf*ns);
    for i=1:nf*ns
        temp = f(:,i);
        E = reshape(temp(3:6),2,2);        
        f_size(i) = det(E);
    end
    
    [~, assign] = sort(f_size);
    
    
    
    f_sort = f(:, assign);
    [~, assign_back] = sort(assign);
    [f_out,d] = extract(im,'sift',f_sort);
%     d = uint8(d*512);
%     [f_out, d] = vl_usift(im, 'Frames', f_sort, 'FloatDescriptors');
    f_out = f_out(:, assign_back);
    d = d(:, assign_back);
    
    % Aggregate and nomarlize
    f_out = reshape(f_out, [6, nf, ns]);
    f_out = f_out(:, :, 1);
    f_out(3:6,:) = frames(3:6,:);
    d = reshape(d, [128, nf, ns]);
    
        
%     dweight = zeros(1,nf,ns-1);
%     for  x = 1:ns-1
%         for y = 1:nf
%             dweight(1,y,x) = norm(d(1,y,x+1)-d(1,y,1));
%         end
%     end
%     
%     
%     for y = 1:nf
%         dweight(1,y,:) = 1+dweight(1,y,:)/sum(dweight(1,y,:))*(ns-1);
%     end
%     
%     for  x = 1:ns-1
%         for y = 1:nf
%             d(:,y,x) = dweight(1,y,x)*d(:,y,x);
%         end
%     end
    
    d_out = mean(single(d), 3);
    
    
    
    
    d_out = mexNormalizeHistogramChar(d_out);
    

end