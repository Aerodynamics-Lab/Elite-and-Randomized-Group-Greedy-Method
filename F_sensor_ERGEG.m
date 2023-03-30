function [time, sensors]=F_sensor_ERGEG(U, p, Lmax, ns, pov)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_ERGEG_sub(U, p, Lmax, ns, pov);
    time=toc;
    sensors=sensors_all(1,:);
end
