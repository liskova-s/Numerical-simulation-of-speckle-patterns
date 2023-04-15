function mask2 = crosstalk(mask,sigma)
sigma = 4*sigma;
kernel = [ceil(sigma*5), ceil(sigma*5)];
gaussian_filter = fspecial('gaussian', kernel, sigma);
gaussian_filter = gaussian_filter / sum(gaussian_filter(:));
mask2 = imfilter(mask, gaussian_filter);
end

