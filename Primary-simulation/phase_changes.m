% Below, there are provided code snippets implementing different phase
% changes, that can be used in the main script.

% 1 change of phases using QR code-like pattern 'qr_mask_slm.mat',
% 'qr_mask_2_slm.mat'

p_change = cell2mat(struct2cell(load('qr_mask_slm.mat')));
p_change = p_change*pi;
p_change = kron(p_change,ones(4));
   
% 2 linear phase change leading to observable horizontal focus shift 
p_change = repmat(linspace(0,300*pi,1920),1080,1); 

% 3 quadratic phase change
[x,y] = meshgrid(-1:0.001:1-0.001,-1:0.001:1-0.001);
z = (x.^2+y.^2);
z = z(461:1540, 41:1960);
p_change = z./max(z,[],'all')*300*pi;

% 4 grid phase change 
mask = ones(10,10);
mask(2:9,2:9)=0;
p_change = repmat(mask,108,192);