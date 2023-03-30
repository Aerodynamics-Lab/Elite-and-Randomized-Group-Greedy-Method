function [time, sensors]=F_sensor_ERGDG(U, p, Lmax, ns, pov)
    [n,~]=size(U);
    tic;
    [sensors_all,History]=F_sensor_ERGDG_sub(U, p, Lmax, ns, pov);
    time=toc;
    
%    [H]=F_calc_sensormatrix(p, n, sensors(1,:));
    sensors=sensors_all(1,:);
end
