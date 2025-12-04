function out = process_aero_run(gravData, testData, p_amb, T_amb, Re_target)
% PROCESS_AERO_RUN
%   gravData, testData : raw CSV arrays (all 14 colum,ns)
%   p_amb  : ambient/static pressure [Pa]
%   T_amb  : ambient temperature [K]
%   Re_target : Reynolds number for this run (150e3 or 300e3)
%
%   Returns struct 'out':
%      alpha_set_deg, alpha_true_deg
%      L, D          
%      CL, CD       
%      q_inf        
%      Re           

    % column indices
    COL_PITCH = 10;
    COL_AXIAL = 7;
    COL_NORMAL = 8;

    % constants 
    c  = 0.1397;        % chord 
    b  = 0.1524;        % span  
    S  = c * b;         % area 
    alpha_offset = -1.7;      % deg

    R_air = 287.058;    % J/(kg·K)

    % Sutherland's law constants (air)
    mu_ref  = 1.716e-5; % kg/(m·s)
    T_ref   = 273.15;   % K
    S_mu    = 110.4;    % K

    % extra gravity data (Fn, Fa vs alpha_set)
    alpha_g = gravData(:, COL_PITCH);      % deg
    FN_g    = gravData(:, COL_NORMAL);     % N (normal)
    FA_g    = gravData(:, COL_AXIAL);      % N (axial)

    % extract test data
    alpha_set = testData(:, COL_PITCH);    % deg
    FN_raw    = testData(:, COL_NORMAL);   % N
    FA_raw    = testData(:, COL_AXIAL);    % N

    % interpolate gravity forces at test angles and subtract
    FN_grav = interp1(alpha_g, FN_g, alpha_set, 'linear', 'extrap');
    FA_grav = interp1(alpha_g, FA_g, alpha_set, 'linear', 'extrap');

    FN = FN_raw - FN_grav;
    FA = FA_raw - FA_grav;

    % correct angle and convert to radians
    alpha_true_deg = alpha_set + alpha_offset;
    alpha_rad      = deg2rad(alpha_true_deg);

    % rotate to lift & drag
    L = FN .* cos(alpha_rad) - FA .* sin(alpha_rad);
    D = FN .* sin(alpha_rad) + FA .* cos(alpha_rad);

    % density and viscosity (from p_amb, T_amb)
    rho = p_amb / (R_air * T_amb);  % kg/m^3

    mu  = mu_ref * (T_amb/T_ref)^(3/2) * (T_ref + S_mu)/(T_amb + S_mu);

    % velocity from target Re, then q_inf
    V = Re_target * mu / (rho * c);       % m/s
    q_inf = 0.5 * rho * V.^2;             % Pa 

    % aero coefficients
    CL = L ./ (q_inf * S);
    CD = D ./ (q_inf * S);

    % uncertainty in CL and CD (error prop)

    dFN   = 0.005;                 % N
    dFA   = 0.005;                 % N
    dAlpha = 0.05 * pi/180;        % rad
    dq    = 0.5;                   % Pa

    % partials for CL
    dCL_dFN    =  cos(alpha_rad)        ./ (q_inf * S);
    dCL_dFA    = -sin(alpha_rad)        ./ (q_inf * S);
    dCL_dAlpha = (-FN .* sin(alpha_rad) - FA .* cos(alpha_rad)) ./ (q_inf * S);
    dCL_dq     = -CL ./ q_inf;

    dCL = sqrt( (dCL_dFN    * dFN   ).^2 + ...
                (dCL_dFA    * dFA   ).^2 + ...
                (dCL_dAlpha * dAlpha).^2 + ...
                (dCL_dq     * dq    ).^2 );

    % partials for CD
    dCD_dFN    =  sin(alpha_rad)        ./ (q_inf * S);
    dCD_dFA    =  cos(alpha_rad)        ./ (q_inf * S);
    dCD_dAlpha = ( FN .* cos(alpha_rad) - FA .* sin(alpha_rad)) ./ (q_inf * S);
    dCD_dq     = -CD ./ q_inf;

    dCD = sqrt( (dCD_dFN    * dFN   ).^2 + ...
                (dCD_dFA    * dFA   ).^2 + ...
                (dCD_dAlpha * dAlpha).^2 + ...
                (dCD_dq     * dq    ).^2 );

    % pack output
    out.alpha_set_deg  = alpha_set;
    out.alpha_true_deg = alpha_true_deg;
    out.L   = L;
    out.D   = D;
    out.CL  = CL;
    out.CD  = CD;
    out.q_inf = q_inf;
    out.Re    = Re_target;
    out.dCL = dCL;
    out.dCD = dCD;

end
