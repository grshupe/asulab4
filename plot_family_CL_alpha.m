function plot_family_CL_alpha(results, family, ReTag, titleText)
% helper functino, generates a plot of the lift coefficient vs angle of
% attack for a selected winglet family at a selected reynolds number

figure; hold on;
labels = strings(1, numel(family));

for k = 1:numel(family)
    cfg = family(k);
    idx = find(strcmp([results.name], cfg));

    alpha = results(idx).(ReTag).alpha_true_deg;
    CL    = results(idx).(ReTag).CL;
    dCL   = results(idx).(ReTag).dCL;

    % vertical error bars for CL
    errorbar(alpha, CL, dCL, 'LineWidth', 1.2, 'LineStyle','-');
    labels(k) = cfg;
end

grid on;
xlabel('Angle of Attack (deg)');
ylabel('C_L');
title(titleText);
legend(labels, 'Location','best');
end
