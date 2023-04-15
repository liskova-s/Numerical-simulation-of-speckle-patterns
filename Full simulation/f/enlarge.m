function w = enlarge(wave, sz)
        w = zeros(sz);
        ws = size(wave);
        x_bord = sz(1)/2-ws(1)/2+1;
        y_bord = sz(2)/2-ws(2)/2+1;
        w(x_bord:x_bord+ws(1)-1,y_bord:y_bord+ws(2)-1) = wave;
    end
