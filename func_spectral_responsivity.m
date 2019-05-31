function [M, resp_bias, noise_sigma2] = func_spectral_responsivity(refl, resp)

[num_sample, num_wavelength] = size(refl);
num_channel = size(resp,2);

M = zeros(num_wavelength, num_channel);
resp_bias = zeros(num_channel, 1);
noise_sigma2 = zeros(num_channel, 1);

%% solve the Cx=d system
C = ones(num_sample, num_wavelength + 1);
C(:,1:num_wavelength) = refl;
d = zeros(num_sample, 1);

for k = 1 : num_channel
    d = resp(:, k);           % camera response of channel k
    [x, dummy, err] = lsqnonneg(C, d);      % solve Cx=d, x is nonnegative
%     x = func_my_pinv(C, 1e-3) * d;
%     err = d - C * x;
    
    M(:,k) = x(1 : num_wavelength);         % spectral responsivity
    resp_bias(k) = x(num_wavelength+1);     % dark current response
    
    noise_sigma2(k) = err' * err / num_sample;    % Gaussian noise, sigma^2
end

