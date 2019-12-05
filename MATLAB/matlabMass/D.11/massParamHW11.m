addpath ./..
massParam

P.makeMovie = true;
%  tuning parameters
%tr = 2; % part (a)
tr = 2.0;%2.2;  % tuned to get fastest possible rise time before saturation.
zeta = 0.707;

P.z_e = 0;
P.F_e = 0;



A = [...
    0, 1;...
    -(P.k/P.m), -(P.b/P.m);...
    ];
B = [0; (1/P.m) ];
C = [...
    1, 0;...
    ];

%Delta_ol = [1, P.b/P.m, P.k/P.m];
%p_ol = roots(Delta_ol);

wn = 2.2/tr;

des_char_poly = [1,2*zeta*wn,wn^2];
des_poles = roots(des_char_poly);

% is the system controllable?
if rank(ctrb(A,B))~=2 
    disp('System Not Controllable'); 
else
    P.K = place(A,B,des_poles); 
    P.kr = -1/(C*inv(A-B*P.K)*B);
end

fprintf('\t K: [%f, %f]\n', P.K(1), P.K(2))
fprintf('\t kr: %f\n', P.kr)