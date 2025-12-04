function plot_family_CL_alpha(results, family, ReTag, titleText)
% Plot CL vs alpha for one family and one Reynolds number
%
% results : struct from loader
% family  : ["none","20deg","40deg","60deg"] etc.
% ReTag   : "Re150" or "Re300"
% titleText : string for the plot title

figure; hold on;
labels = strings(1, numel(family));

for k = 1:numel(family)
    cfg = family(k);

    % find the matching result entry
    idx = find(strcmp([results.name], cfg));

    % extract data
    alpha = results(idx).(ReTag).alpha_true_deg;
    CL    = results(idx).(ReTag).CL;

    plot(alpha, CL, 'LineWidth', 1.6);
    labels(k) = cfg;
end

grid on;
xlabel('Angle of Attack (deg)');
ylabel('C_L');
title(titleText);
legend(labels, 'Location','best');

end
