function [time, sensors]=F_sensor_RGDG(U, p, Lmax, ns)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_RGDG_sub(U, p, Lmax, ns);
    time=toc;
    
%    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    sensors=sensors_all(1,:);
end
