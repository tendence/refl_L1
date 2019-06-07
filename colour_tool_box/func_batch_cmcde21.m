function de = func_batch_cmcde21(refl, refl_pred, illu)

num_sample = size(refl,2);
de = zeros(num_sample, 1);

for i = 1 : num_sample
    de(i) = func_refl_cmcde21(refl(:,i), refl_pred(:,i), illu);
end