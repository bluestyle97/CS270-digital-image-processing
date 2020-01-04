function q = guided_filter(I, p, r, eps)

[m, n] = size(I);

N = window_sum_filter(ones(m, n), r);

mean_I = window_sum_filter(I, r) ./ N;
mean_p = window_sum_filter(p, r) ./ N;

corr_II = window_sum_filter(I .* I, r) ./ N;
corr_Ip = window_sum_filter(I .* p, r) ./ N;

var_I = corr_II - mean_I .* mean_I;
cov_Ip = corr_Ip - mean_I .* mean_p;

a = cov_Ip ./ (var_I + eps);
b = mean_p - a .* mean_I;

mean_a = window_sum_filter(a, r) ./ N;
mean_b = window_sum_filter(b, r) ./ N;

q = mean_a .* I + mean_b;

end