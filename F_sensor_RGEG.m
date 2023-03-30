function [time, sensors]=F_sensor_RGEG(U, p, Lmax,ns)
    % objective function: minimum eigenvalue(CCT), (CTC)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_RGEG_sub(U, p, Lmax,ns);
    time=toc;
    sensors=sensors_all(1,:);
end