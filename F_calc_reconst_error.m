function [Perror, xreconst] = F_calc_reconst_error(Xtest, sensors, U)

    Y = Xtest(sensors,:);
    C = U(sensors,:);
    Zestimate = pinv(C)*Y; %B = pinv(A) returns the Moore-Penrose Pseudoinverse of matrix A.

    Xreconst = U * Zestimate;
    Perror=norm(Xreconst-Xtest,'fro')/norm(Xtest,'fro');
    xreconst=Xreconst(:,1);   %fist single snapshot of reconstructed data
end
