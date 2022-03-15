%% reservoir
clear all
clc

x(60,41) = 0;
for ii = 1:3
    for i = 1:12
        z = i*3 + 12;
        x(z,18:24) = 1;
    end
end
