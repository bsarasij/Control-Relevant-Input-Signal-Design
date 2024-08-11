function eff=effval(X,Fe)%EFFVAL Calculate the effective value of all the column vectors% present in the matrix X (Fourier coefficients). %%	P.A.N. Guillaume - version 1 / 19 November 1990%	Copyright (c) 1990 by dept. ELEC, V.U.B.%X(1,:)=sqrt(2)*X(1,:);    % Correction for the DC-componentif nargin==2, X=X(Fe(:),:); endeff=sqrt(sum(abs(X).^2)/2);