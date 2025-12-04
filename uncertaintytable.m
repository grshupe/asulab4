
% expected columns:
% 1 = config name
% 2 = temperature (°C)
% 3 = pressure (kPa)
% 4 = Re1
% 5 = Re2

opts = detectImportOptions("G8_Conditions.txt");
conds = readtable("G8_Conditions.txt", opts);

% constants
R = 287.05;           % J/(kg*K), specific gas constant for air
dP = 0.1 * 1000;      % convert kPa → Pa  (plus/minus 0.1 kPa)
dT = 1.0;             % C to K (same magnitude)

% preallocate
rho  = zeros(height(conds),1);
drho = zeros(height(conds),1);

for i = 1:height(conds)

    T_C  = conds{i,2};         % C
    P_kPa = conds{i,3};        % kPa

    T = T_C + 273.15;          % convert to Kelvin
    P = P_kPa * 1000;          % convert to Pascals
   
    drho(i) = sqrt( ( (1/(R*T)) * dP )^2 + ( (-P/(R*T^2)) * dT )^2 );
end

% build ouput table
Config = string(conds{:,1});
Temp_C = round(conds{:,2}, 2);
Press_kPa = round(conds{:,3}, 2);
Density = round(rho, 4);
Delta_rho = round(drho, 5);

TableA1 = table(Config, Temp_C, Press_kPa, Density, Delta_rho);

% export
writetable(TableA1, "Table_A1_Density_Uncertainty.csv");

disp("Table A-1 created successfully.");
