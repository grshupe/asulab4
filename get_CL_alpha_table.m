function T = get_CL_alpha_table(results, config, ReTag)

    idx = find(string({results.name}) == string(config));
    if isempty(idx)
        error("Configuration '%s' not found in results.", config);
    end

    data = results(idx).(ReTag);

    % Rounded versions for table readability
    alpha = round(data.alpha_true_deg, 3);
    CL    = round(data.CL, 4);
    dCL   = round(data.dCL, 5);

    T = table(alpha, CL, dCL, ...
        'VariableNames', {'alpha_deg','CL','dCL'});
end
