function rms = func_batch_rms(refl, refl_pred)

[num_point, num_sample] = size(refl);
rms = zeros(num_sample, 1);

for i = 1 : num_sample
    refl_err = refl(:,i)-refl_pred(:,i);
    rms(i) = sqrt(sum(refl_err .^2) / num_point);
end

% rms = mean(sqrt(sum((refl_err.^2),1)/num_wavelength));