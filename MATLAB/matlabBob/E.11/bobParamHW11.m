addpath ./..
bobParam

P.alpha = 0.0;
P.sigma = .05;
P.beta = (2*P.sigma-P.Ts)/(2*P.sigma+P.Ts);


P.makeMovie = true;
P.title = 'ballbeam.mp4';

%  tuning parameters
%tr = 2; % part (a)


M = 10;

P.theta_max = 90;%30.0*pi/180.0;

P.ze = P.length/2;
b0 = P.length/(P.m2*P.length^2/3+P.m1*P.ze^2);



% tuning parameters
tr_z = 1.2;
tr_th = .5;%M*tr_z;

wn_z = 2.2/tr_z;
wn_th = 2.2/tr_th;

zeta_th = 0.707;
zeta_z  = 0.707;

% state space design
A = [...
    0, 0, 1, 0;...
    0, 0, 0, 1;...
    0, -P.m1*P.g/((P.m2*P.length^2)/3+P.m1*(P.length/2)^2), 0, 0;...
    -P.g, 0, 0, 0;...

];
B = [0; 0; P.length/(P.m2*P.length^2/3+P.m1*P.length^2/4); 0];
C = [...
    1, 0, 0, 0;...
    0, 1, 0, 0;...
    ];

% gain selection
ol_char_poly = charpoly(A);
des_char_poly = conv([1,2*zeta_th*wn_th,wn_th^2],...
                [1,2*zeta_z*wn_z,wn_z^2]);
des_poles = roots(des_char_poly);
% is the system controllable?
if rank(ctrb(A,B))~=4
    disp('System Not Controllable'); 
else
    P.K = place(A,B,des_poles);
    P.kr = -1/([0, 1, 0, 0]*inv(A-B*P.K)*B);
end

sprintf('K: (%f, %f, %f, %f)\nkr: %f\n', P.K(1), P.K(2), P.K(3), P.K(4), P.kr)


