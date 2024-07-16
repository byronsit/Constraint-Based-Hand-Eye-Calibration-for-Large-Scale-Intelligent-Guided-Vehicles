% 在本身AX=XB任务上，增加了一个变化量。
% 也就是产生一个new_A,他意味着外参X发生一定的变化,所以要额外一个轨迹。
clc
clear all
close all

rng(4);

%% 相机外参设置
Tx = 7.345465303849309; Ty = 0.1395879022194233; Tz = 1.495; % 平移
qx = 0.5744485910542397; qy = -0.5731322100778303; qz = 0.414850377485667; qw = -0.4116156584814286;
%qx = 0; qy =   0.7071; qz = 0; qw =   0.7071;
% 添加噪声
noise_level_translation = 0; % 平移噪声水平(米)
noise_level_rotation = 0; % 旋转噪声水平(弧度)

% 创建四元数对象
q = quaternion([qw qx qy qz]);
%q = quaternion([1 0 0 0]);
R_bc = quat2rotm(q);
R_cb = R_bc.';

% 创建平移向量
t_bc = [Tx; Ty; Tz];
t_cb = -R_cb*t_bc;

%创建旋转矩阵T
T_cb = [R_cb, t_cb;0 0 0 1]


% 扰动量设置
diff_x = 0; % 1cm的变化
diff_y = 0; % 1cm的变化
diff_z = -0.4;  % 40cm的变化

diff_pitch = 30; % 单位:度
diff_yaw = 14;    % 单位:度
diff_roll = 5;   % 单位:度

% 创建扰动的变换矩阵

%% gpt觉得我写的不对，统一改为四元数了
%R_diff_pitch = eul2rotm([0, deg2rad(diff_pitch), 0], 'XYZ');
% R_diff_yaw   = eul2rotm([0, 0, deg2rad(diff_yaw)], 'ZYX');
% R_diff_roll  = eul2rotm([deg2rad(diff_roll), 0, 0], 'XYZ');

% R_diff_pitch = eul2rotm([0, deg2rad(diff_pitch), 0], 'ZYX');
% R_diff_yaw   = eul2rotm([0, 0, deg2rad(diff_yaw)], 'ZXY');
% R_diff_roll  = eul2rotm([deg2rad(diff_roll), 0, 0], 'XYZ');


%我改为四元数来写
qy = [cosd(diff_pitch/2), 0, sind(diff_pitch/2), 0];
qz = [cosd(diff_yaw/2), 0, 0, sind(diff_yaw/2)];
qx = [cosd(diff_roll/2),sind(diff_roll/2),0,0];

R_diff_pitch = (q2R(qy)');
R_diff_yaw   = (q2R(qz)');
R_diff_roll  = (q2R(qx)');
%b_R_cprime_c = simplify(q2R(qy)).'* simplify(q2R(qz)).'* simplify(q2R(qx)).';
% 旋转部分
b_R_cprime_c = R_diff_pitch * R_diff_yaw * R_diff_roll; %假设是知道的！

R_cprime_c = R_cb * b_R_cprime_c.' * R_cb.';


%% gpt让我重写成如下形式
% R_diff_pitch = eul2rotm([0, deg2rad(diff_pitch), 0], 'XYZ');
% R_diff_yaw   = eul2rotm([0, 0, deg2rad(diff_yaw)], 'XYZ');  % 使用'XYZ'而不是'ZYX'
% R_diff_roll  = eul2rotm([deg2rad(diff_roll), 0, 0], 'XYZ');
% 
% b_R_cprime_c = R_diff_yaw * R_diff_pitch * R_diff_roll;
% 
% R_cprime_c = R_cb * b_R_cprime_c * R_cb';  % 使用这个公式
%% 结束


R_cprime_b = R_cprime_c * R_cb;

% 平移部分
b_t_c_c_prime = [diff_x; diff_y; diff_z];                % 提前定义好的
t_cprime_c = R_cprime_b * (-b_t_c_c_prime);              %check
t_c_cprimbe = R_cb * (b_t_c_c_prime);                    %check

%% 下面构造大T矩阵
% 对原始变换矩阵进行扰动
T_cprime_c = [R_cprime_c, t_cprime_c;0 0 0 1];
T_cprime_b = T_cprime_c * T_cb; %???
T_b_cprime = inv(T_cprime_b);
T_bc = inv(T_cb);

% 从扰动后的变换矩阵中提取平移向量和四元数
q_cprime_b = tform2quat(T_cprime_b);
t_cprime_b = T_cprime_b(1:3, 4);



% 可视化设置
axis_length = 10; % 坐标轴长度
axis_space_grid = 15; % 要画多少个坐标轴表示相机的姿态
need_plot_no_noise = false;

%% 参数设置
% 时间参数
t = linspace(0, 1.5*pi, 200); % 时间变量,1.5pi确保方向没反

% 生成8字轨迹参数
x = sin(t);
y = sin(t).*cos(t);
z = zeros(size(t)); % 地面是100%平的
x = x * 40;
y = y * 40;

% 车体中心轨迹
odom_trajectory = [x; y; z];

% 从四元数创建旋转矩阵
R_cam_to_body = R_cb; %quat2rotm([qw qx qy qz]);
T_cam_to_body = T_cb; %;[R_cam_to_body, [Tx; Ty; Tz]; 0 0 0 1];
T_body_to_cam = inv(T_cam_to_body);

%% 初始化body的轨迹.
body_trajectory = odom_trajectory;
body_pose =  cell(1, length(t));


camera_trajectory = zeros(size(odom_trajectory));
camera_poses = cell(1, length(t)); % 存储相机位姿的元胞数组

camera_new_trajectory = zeros(size(odom_trajectory));  % 变化后的新的相机的轨迹
camera_new_poses = cell(1, length(t));                % 新的相机的元胞的pose


for i = 1:length(t)
    % 计算车体的旋转矩阵
    if i < length(t)
        x_axis = odom_trajectory(:, i+1) - odom_trajectory(:, i);
    else
        x_axis = odom_trajectory(:, i) - odom_trajectory(:, i-1);
    end
    x_axis = x_axis / norm(x_axis);
    
    z_axis = [0; 0; 1];
    y_axis = cross(z_axis, x_axis);
    y_axis = y_axis / norm(y_axis);
    z_axis = cross(x_axis, y_axis);
    
    R_wb = [x_axis, y_axis, z_axis];
    %R_wb = eye(3); %debug，不考虑方向了
    R_bw = R_wb.';  
    
    T_wb = [R_wb, odom_trajectory(:, i); 0 0 0 1];
    T_bw = inv(T_wb);
    body_pose{i} = T_wb;

    % 本身相机的轨迹
    T_wc =  T_wb * T_bc;
    camera_trajectory(:, i) = T_wc(1:3, 4);
    camera_poses{i} = T_wc; % 存储当前位姿

    % 相机被改变了一次，变成cprimer,随后产生的轨迹
    T_w_cprime = T_wb * T_b_cprime;
    camera_new_trajectory(:, i) = T_w_cprime(1:3, 4);
    camera_new_poses{i} = T_w_cprime; % 存储当前位姿
end

 % plot3(camera_trajectory(1,:), camera_trajectory(2,:), camera_trajectory(3,:), 'k-', 'LineWidth', 2);
 % hold on
 % plot3(camera_new_trajectory(1,:), camera_new_trajectory(2,:), camera_new_trajectory(3,:), 'x' );
 % return



%% 带噪声的相机轨迹(相机轨迹)
camera_trajectory_noisy = zeros(size(camera_trajectory));
camera_poses_noisy = cell(1, length(t)); % 存储带噪声的相机位姿的元胞数组
camera_trajectory_noisy(:,1) = camera_trajectory(:,1); % 初始位姿不变
camera_poses_noisy{1} = camera_poses{1}; % 存储初始位姿

A_matrices = cell(1, length(t)-1); % 存储A矩阵的元胞数组
B_matrices = cell(1, length(t)-1); % 存储B矩阵的元胞数组

%R_body_to_world_prev = eye(3); % 初始化前一时刻的车体旋转矩阵

% 在相邻位姿之间的变换上添加噪声
for i = 2:length(t)
    % 计算当前位姿和前一位姿之间的变换
    T_prev = camera_poses{i-1};
    T_curr = camera_poses{i};
    T_diff = inv(T_prev) * T_curr;
    
    % 提取旋转矩阵和平移向量
    R_diff = T_diff(1:3,1:3);
    t_diff = T_diff(1:3,4);
    
    % 为旋转矩阵添加随机噪声
    noise_rotation = noise_level_rotation * randn(3,1);
    R_noisy = R_diff * rotx(noise_rotation(1)) * roty(noise_rotation(2)) * rotz(noise_rotation(3));
    
    % 为平移向量添加随机噪声  
    noise_translation = noise_level_translation * randn(3,1);
    t_noisy = t_diff + noise_translation;
    
    % 重构带噪声的变换矩阵
    T_noisy_diff = [R_noisy, t_noisy; 0 0 0 1];
    
    % 将带噪声的变换应用到前一位姿,得到当前的带噪声位姿
    T_noisy = camera_poses_noisy{i-1} * T_noisy_diff;
    camera_trajectory_noisy(:,i) = T_noisy(1:3, 4);
    camera_poses_noisy{i} = T_noisy; % 存储当前带噪声的位姿
    
    % 计算A矩阵
    A = inv(camera_poses{i-1}) * camera_poses{i};
    A_matrices{i-1} = A;
    
    % 计算B矩阵
    % B = inv(T_cam_to_body) * A * T_cam_to_body;
    % B_matrices{i-1} = B;
    
    %换一个B的计算方式，改为利用body的变化量
    T_diff_B = inv(body_pose{i-1}) * body_pose{i}
    B = inv(T_cb) * A * (T_cb)
    assert( sum(sum(T_diff_B-B<1e-4))==16)
    B_matrices{i-1} = B;

%    R_body_to_world_prev = R_body_to_world; % 更新前一时刻的车体旋转矩阵
end


%% 经过pitch和z变化的【新的】相机轨迹
camera_new_trajectory_noisy = zeros(size(camera_new_trajectory));
camera_new_poses_noisy = cell(1, length(t)); % 存储带噪声的相机位姿的元胞数组
camera_new_trajectory_noisy(:,1) = camera_new_trajectory(:,1); % 初始位姿不变
camera_new_poses_noisy{1} = camera_new_poses{1}; % 存储初始位姿

A_matrices_new = cell(1, length(t)-1); % 存储A矩阵的元胞数组
B_matrices_new = cell(1, length(t)-1); % 存储A矩阵的元胞数组
%R_body_to_world_prev = eye(3); % 初始化前一时刻的车体旋转矩阵


% 在相邻位姿之间的变换上添加噪声
for i = 2:length(t)
    % 计算当前位姿和前一位姿之间的变换
    T_prev = camera_new_poses{i-1};
    T_curr = camera_new_poses{i};
%    T_diff = T_prev * inv(T_curr) ; %T_past_current
    T_diff = inv(T_prev) * T_curr;

    % 提取旋转矩阵和平移向量
    R_diff = T_diff(1:3,1:3);
    t_diff = T_diff(1:3,4);
    
    % 为旋转矩阵添加随机噪声
    noise_rotation = noise_level_rotation * randn(3,1);
    R_noisy = R_diff * rotx(noise_rotation(1)) * roty(noise_rotation(2)) * rotz(noise_rotation(3));
    
    % 为平移向量添加随机噪声  
    noise_translation = noise_level_translation * randn(3,1);
    t_noisy = t_diff + noise_translation;

    % 重构带噪声的变换矩阵
    T_noisy_diff = [R_noisy, t_noisy; 0 0 0 1];
    
    % 将带噪声的变换应用到前一位姿,得到当前的带噪声位姿
    %T_noisy = inv(inv(camera_new_poses_noisy{i-1}) * T_noisy_diff);
    T_noisy = inv(T_noisy_diff) * camera_new_poses_noisy{i-1};
    T_noisy = camera_new_poses_noisy{i-1} * T_noisy_diff;



    camera_new_trajectory_noisy(:,i) = T_noisy(1:3, 4);
    camera_new_poses_noisy{i} = T_noisy; % 存储当前带噪声的位姿
    
    % 计算A_new矩阵
    A_new = inv(camera_new_poses_noisy{i-1}) * camera_new_poses_noisy{i};
    A_matrices_new{i-1} = A_new;

    %计算新的B_new矩阵，但是B矩阵本质应该是A_new去convert过去，应该一样的
    % B = T_cam_to_body * A * inv(T_cam_to_body);
    % B_matrices{i-1} = B;
end

%% 测试AX=XB

err_translation = []; % 存储平移误差
err_rotation = []; % 存储旋转误差
[err_translation, err_rotation] = test_AX_XB(A_matrices, B_matrices, T_cb);
max_err_translation = max(err_translation)
max_err_rotation = max(err_rotation)



% 测试新的camera位置
[err_translation, err_rotation] = test_AX_XB(A_matrices_new, B_matrices, T_cprime_b);
max_err_translation = max(err_translation)
max_err_rotation = max(err_rotation)

% A_matrices是原始的A矩阵。 GT是T_cb
% A_matrices是经过变化的A矩阵。 GT是T_cprime_b
% 这里的diff_pitch和diff_z是给定的先验信息。
save('simulated_AB', 'A_matrices', 'B_matrices','A_matrices_new', 'T_cb', 'T_cprime_b', 'diff_pitch', 'diff_z');


% 测试推导的公式
for i = 1 : length(A_matrices)
AA{i}      = A_matrices{i} * T_cprime_b;
AA_test{i} = A_matrices_new{i}*T_cprime_b;
B_matrices_new{i} = T_cb * B_matrices{i} * T_bc;
end
[err_translation, err_rotation] = test_AX_XB(A_matrices_new, B_matrices_new, T_cprime_c);
max_err_translation = max(err_translation)
max_err_rotation = max(err_rotation)


%% 绘制三个轨迹在同一个图中,并在特定位置绘制位姿坐标轴
%绘制原始轨迹
figure;
plot3(x, y, z,'-', 'Color', [1, 0.5, 0], 'LineWidth', 2);
hold on;

plot3(camera_trajectory_noisy(1,:), camera_trajectory_noisy(2,:), camera_trajectory_noisy(3,:), 'k-', 'LineWidth', 2);
plot3(camera_new_trajectory_noisy(1,:), camera_new_trajectory_noisy(2,:), camera_new_trajectory_noisy(3,:), '-','Color', [0.5, 0, 0.5], 'LineWidth', 2);

% 绘制原始相机轨迹的 【相机坐标轴】
pose_indices = round(linspace(1, length(t), axis_space_grid)); % 选择10个等间隔的位置

for i = 1:length(pose_indices)
    idx = pose_indices(i);
    
    % 绘制无噪声的位姿坐标轴
    if need_plot_no_noise 
        T_cam_to_world = camera_poses{idx};
        R_cam_to_world = T_cam_to_world(1:3, 1:3);
        t_cam_to_world = T_cam_to_world(1:3, 4);
        plotCoordinateFrame(R_cam_to_world, t_cam_to_world, axis_length);
    end
    % 绘制【body】坐标轴
    T_noisy_cam_to_world = body_pose{idx};
    R_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 1:3);
    t_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 4);
    plotCoordinateFrame(R_noisy_cam_to_world, t_noisy_cam_to_world, axis_length);



    % 绘制【原始相机】带噪声的位姿坐标轴
    T_noisy_cam_to_world = camera_poses_noisy{idx};
    R_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 1:3);
    t_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 4);
    plotCoordinateFrame(R_noisy_cam_to_world, t_noisy_cam_to_world, axis_length);

    % 绘制【新相机】的相机未姿坐标轴
    T_noisy_cam_new_to_world = camera_new_poses_noisy{idx};
    R_noisy_cam_new_to_world = T_noisy_cam_new_to_world(1:3, 1:3);
    t_noisy_cam_new_to_world = T_noisy_cam_new_to_world(1:3, 4);
    plotCoordinateFrame(R_noisy_cam_new_to_world, t_noisy_cam_new_to_world, axis_length);

end



title('车体中心轨迹、相机轨迹和带噪声的相机轨迹');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('车体中心轨迹', '带噪声的相机轨迹', '全新的带噪声相机轨迹');
axis equal;
grid on;




%% 绘制坐标轴的函数
function plotCoordinateFrame(R, t, axis_length, color)
    % 绘制x轴(红色)
    hold on;
    x_axis = R(:,1) * axis_length;
    plot3([t(1), t(1)+x_axis(1)], [t(2), t(2)+x_axis(2)], [t(3), t(3)+x_axis(3)], '-', 'LineWidth', 2, 'Color', [1, 0, 0]);
    
    hold on;
    % 绘制y轴(绿色)
    y_axis = R(:,2) * axis_length;
    plot3([t(1), t(1)+y_axis(1)], [t(2), t(2)+y_axis(2)], [t(3), t(3)+y_axis(3)], '-', 'LineWidth', 2, 'Color', [0, 1, 0]);
    
    hold on;
    % 绘制z轴(蓝色)
    z_axis = R(:,3) * axis_length;
    plot3([t(1), t(1)+z_axis(1)], [t(2), t(2)+z_axis(2)], [t(3), t(3)+z_axis(3)], '-', 'LineWidth', 2, 'Color', [0, 0, 1]);
end