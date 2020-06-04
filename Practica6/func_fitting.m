function y = func_fitting(x)
% 
kp = x(1);
ki = x(2);
kd = x(3);

% 
set_param("practica2_2_1_PID/PID Controller","P","kp","I","ki","D","kd");

% 
out = sim("practica2_2_1_PID.slx", "SrcWorkspace", "Current");

% 
iae = sum(abs(out.error.Data));
%itae = sum(out.error.Time .* abs(out.error.Data));

% Retornamos el valor de la función
y = iae;
end