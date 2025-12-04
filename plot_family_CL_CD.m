function plot_family_CL_CD(results, family, ReTag, titleText)
% helper function, generates a drag polar for a selected winglet family at
% a selected reynolds number

figure; hold on;
labels = strings(1, numel(family));

for k = 1:numel(family)
    cfg = family(k);
    idx = find(strcmp([results.name], cfg));

    CL  = results(idx).(ReTag).CL;
    CD  = results(idx).(ReTag).CD;
    dCL = results(idx).(ReTag).dCL;
    dCD = results(idx).(ReTag).dCD;

    % main curve
    plot(CD, CL, 'LineWidth', 1.2);
    labels(k) = cfg;

    % vertical error bars
    hV = errorbar(CD, CL, dCL, 'LineStyle','none', 'LineWidth', 1.0);
    set(hV, 'HandleVisibility','off'); 

    % horizontal error bars 
    for n = 1:numel(CD)
        xL = CD(n) - dCD(n);
        xR = CD(n) + dCD(n);
        y  = CL(n);
        hH = line([xL xR], [y y], 'LineWidth', 1.0);
        set(hH, 'HandleVisibility','off');
    end
end

grid on;
xlabel('C_D');
ylabel('C_L');
title(titleText);
legend(labels, 'Location','best');

end
