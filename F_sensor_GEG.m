function [time, sensors]=F_sensor_GEG(U, p, Lmax)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_GEG_sub(U, p, Lmax);
    time=toc;
    sensors=sensors_all(1,:);
end