close all

u0 = [ones(20, 100);
      ones(60, 10), zeros(60, 20), ones(60, 10), zeros(60, 20), ones(60, 10), zeros(60, 20), ones(60, 10);
      ones(20, 100)];

% u0 = double(rgb2gray(imread('lenna.png')))/256;

imshow(u0)
pause

u0 = awgn(u0, 20); %, 'measured'); % gaussian noise, snr

figure
imshow(u0)
pause


s = size(u0);
h = 1 / s(1);
dt = h^2;
lambda = 1e-8;

u = u0;
unew = u*0;
t = 0;

for ts = 1:50

    for i = 2:s(1)-1
        for j = 2:s(1)-1   
            x = D(u(i,j), u(i+1,j), u(i,j+1), u(i,j-1)) - D(u(i-1,j), u(i,j), u(i-1,j+1), u(i-1,j-1));
            y = D(u(i,j), u(i,j+1), u(i+1,j), u(i-1,j)) - D(u(i,j-1), u(i,j), u(i+1,j-1), u(i-1,j-1));
            unew(i,j) = u(i,j) + dt*(x/h + y/h - lambda*(u(i,j) - u0(i,j)));
        end
        unew(i,1) = unew(i,2);
        unew(i,s(1)) = unew(i,s(1)-1);
    end
    unew(1,:) = unew(2,:);
    unew(s(1),:) = unew(s(1)-1,:);
    
    u = unew;

    if mod(ts, 10) == 0
        figure
        imshow(u)
        pause
    end
    t = t+dt;
end

imshow(u)


function z = D(o, a, b_p, b_m)
    denom = sqrt( (a-o)^2 + (minmod(b_p-o, o-b_m))^2);
    if denom == 0
        z = 0;
    else
        z = (a-o)/denom;
    end

    beta = 0.0001;
    z = (a-o)/(denom+beta);
end

function m = minmod(a, b)
    m = min(abs(a), abs(b));
    m = (sign(a) + sign(b)) * m / 2;
end

