addpath ./..
drnParam

P.makeMovie = true;
P.title = 'vtol.mp4';

P.alpha = 0.2;

tr_h = 8;
zeta_h = .707;
tr_z = 8;
M = 10;
zeta_z = .707;
zeta_th = .707;

wn_h = 2.2/tr_h;
Delta_cl_d = [1,2*zeta_h, wn_h^2];
P.kp_h = Delta_cl_d(3)*(P.mc+2*P.mr);
P.kd_h = Delta_cl_d(2)*(P.mc+2*P.mr);
P.Fe = (P.mc +2*P.mr)*P.g;


b0 = 1/(P.Jc+2*P.mr*P.d^2);
tr_th = tr_z/M;
wn_th = 2.2/tr_th;
P.kp_th = wn_th^2/b0;
P.kd_th = 2*zeta_th*wn_th/b0;

k_DC_th = 1;


b1 = -P.Fe/(P.mc+2*P.mr);
al = P.mu/(P.mc+2*P.mr);
wn_z = 2.2/tr_z;
P.kp_z = wn_z^2/b1;
P.kd_z = (2*zeta_z*wn_z-al)/b1;




%Delta_cl_d = poly([-.3,-.2]);
%P.kp_h = Delta_cl_d(3)*(P.mc+2*P.mr);
%P.kd_h = Delta_cl_d(2)*(P.mc+2*P.mr);


fprintf('\t kp_z: %f\n', P.kp_z);
fprintf('\t kd_z: %f\n', P.kd_z);
fprintf('\t kd_h: %f\n', P.kd_h);
fprintf('\t kd_h: %f\n', P.kd_h);
fprintf('\t kd_th: %f\n', P.kd_th);
fprintf('\t kd_th: %f\n', P.kp_th);
