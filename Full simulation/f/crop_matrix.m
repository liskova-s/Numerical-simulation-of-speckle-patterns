function out = crop_matrix(matrix, sz)
    mattemp=matrix;
    mattemp = imgaussfilt(abs(mattemp),10);
    mattemp(mattemp<1000) = 0;
    xsum = sum(mattemp,1);
    [~,i] = max(xsum);
     xcenter = i;
    ycenter = 3998;
    out = matrix(ycenter-sz(1)/2:ycenter+sz(1)/2,xcenter-sz(2)/2:xcenter+sz(2)/2);
end