function [fitresult, gof] = kfit(sigma, k_best)
%kfit(SIGMA,K_BEST)
%  Create a fit.
%
%  Data for 'k_fit' fit:
%      X Input : sigma
%      Y Output: k_best
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 29-Dec-2018 01:55:16


%% Fit: 'k_fit'.
[xData, yData] = prepareCurveData( sigma, k_best );

% Set up fittype and options.
ft = fittype( 'poly4' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'k_fit' );
h = plot( fitresult, xData, yData );
legend( h, 'k_best vs. sigma', 'k_fit', 'Location', 'NorthEast' );
% Label axes
xlabel sigma
ylabel k_best
grid on


