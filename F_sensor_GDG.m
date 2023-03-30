function [time, sensors]=F_sensor_GDG(U, p, Lmax)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_GDG_sub(U, p, Lmax);
    time=toc;
    
    %[H]=F_calc_sensormatrix(p, n, sensors(1,:));
    sensors=sensors_all(1,:);
end
