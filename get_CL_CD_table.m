function T = get_CL_CD_table(results, config, ReTag)
% Returns a table of C_D, C_L, dCD, dCL for a given config & Reynolds number.

    % Find matching config
    idx = find(string({results.name}) == string(config));
    if isempty(idx)
        error("Configuration '%s' not found in results.", config);
    end

    data = results(idx).(ReTag);

    % Rounded for readability
    CD  = round(data.CD, 4);
    CL  = round(data.CL, 4);
    dCD = round(data.dCD, 5);
    dCL = round(data.dCL, 5);

    % Build table
    T = table(CD, CL, dCD, dCL, ...
        'VariableNames', {'CD','CL','dCD','dCL'});
end
