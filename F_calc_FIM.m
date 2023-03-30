function [FIM] = F_calc_FIM(U,sensors,p,r)
    C = U(sensors,:);
    if (p < r)
       FIM = C*C';
    elseif (p >= r)
       FIM = C'*C;
    end
end