addpath ./..
drnParam

P.makeMovie = true;
P.title = 'vtol.mp4';

P.alpha = 0.2;



tr_h = 8;%8;
tr_h = tr_h/4;
wn_h = 2.2/tr_h;
zeta_h = .707;


tr_z = 8;%8;
tr_z = tr_z/4;
wn_z = 2.2/tr_z;
zeta_z = .707;

tr_th = tr_z/10;
wn_th = 2.2/tr_th;
zeta_th = .707;

P.Fe = ((P.mc+2*P.mr)*P.g);
P.F_tildemax = 2*P.F_max - P.Fe;
P.taumax = (P.F_max - P.Fe/2)/P.d;


P.sigma = .05;
P.Ftildemax = 2*P.F_max-P.Fe;
P.taumax = (P.F_max-P.Fe/2)/P.d;

A_lon = [...
    0, 1;...
    0, 0;...
    ];
B_lon = [0; 1/(P.mc+2*P.mr)];
C_lon = [1, 0:0,0];
A_lat = [...
    0, 0, 1, 0;...
    0, 0, 0, 1;...
    0, -(P.Fe/(P.mc+2*P.mr)), -(P.mu/(P.mc+2*P.mr)), 0;...
    0, 0, 0, 0;...
    ];
B_lat = [0; 0; 0; 1/(P.Jc+2*P.mr*P.d^2)];
C_lat = [...
    1, 0, 0, 0;...
    0, 1, 0, 0];


des_char_poly_lon = [1,2*zeta_h*wn_h,wn_h^2];
des_poles_lon = roots(des_char_poly_lon);

des_char_poly_lat = conv([1,2*zeta_z*wn_z,wn_z^2],...
                [1,2*zeta_th*wn_th,wn_th^2]);
des_poles_lat = roots(des_char_poly_lat);


if rank(ctrb(A_lon,B_lon))~=2
    disp('System Not Controllable'); 
else
    P.K_lon = place(A_lon,B_lon,des_poles_lon);
    P.kr_lon = -1/([1,0]*inv(A_lon-B_lon*P.K_lon)*B_lon);
end

if rank(ctrb(A_lat,B_lat))~=4
    disp('System Not Controllable'); 
else
    P.K_lat = place(A_lat,B_lat,des_poles_lat);
    P.kr_lat = -1/([1,0,0,0]*inv(A_lat-B_lat*P.K_lat)*B_lat);
end

sprintf('K: (%f, %f, %f, %f)\nkr: %f\n', P.K_lat(1), P.K_lat(2), P.K_lat(3), P.K_lat(4), P.kr_lat)
sprintf('K: (%f, %f, %f, %f)\nkr: %f\n', P.K_lon(1), P.K_lon(2), P.kr_lon)

%Delta_cl_d = poly([-.3,-.2]);
%P.kp_h = Delta_cl_d(3)*(P.mc+2*P.mr);
%P.kd_h = Delta_cl_d(2)*(P.mc+2*P.mr);


