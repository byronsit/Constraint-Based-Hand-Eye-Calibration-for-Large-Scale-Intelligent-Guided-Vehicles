clc
clear all
close all

%% 相机外参设置
Tx = 7.345465303849309; Ty = 0.1395879022194233; Tz = 1.495; % 平移
qx = 0.5744485910542397; qy = -0.5731322100778303; qz = 0.414850377485667; qw = -0.4116156584814286;
% 添加噪声
noise_level_translation = 0; % 平移噪声水平(米)
noise_level_rotation = 0; % 旋转噪声水平(弧度)

% 可视化设置
axis_length = 1; % 坐标轴长度
axis_space_grid = 15; % 要画多少个坐标轴表示相机的姿态
need_plot_no_noise = false;

%% 参数设置
% 时间参数
t = linspace(0, 2*pi, 200); % 时间变量

% 生成8字轨迹参数
x = sin(t);
y = sin(t).*cos(t);
z = zeros(size(t)); % 地面是100%平的
x = x * 40;
y = y * 40;

% 车体中心轨迹
odom_trajectory = [x; y; z];

% 从四元数创建旋转矩阵
R_cam_to_body = quat2rotm([qw qx qy qz]);
T_cam_to_body = [R_cam_to_body, [Tx; Ty; Tz]; 0 0 0 1];
T_body_to_cam = inv(T_cam_to_body);

%% 计算相机的轨迹
camera_trajectory = zeros(size(odom_trajectory));
camera_poses = cell(1, length(t)); % 存储相机位姿的元胞数组

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
    
    R_body_to_world = [x_axis, y_axis, z_axis];
    
    T_body_to_world = [R_body_to_world, odom_trajectory(:, i); 0 0 0 1];
    T_cam_to_world = T_body_to_world * T_cam_to_body;
    camera_trajectory(:, i) = T_cam_to_world(1:3, 4);
    camera_poses{i} = T_cam_to_world; % 存储当前位姿
end

% 初始化带噪声的相机轨迹
camera_trajectory_noisy = zeros(size(camera_trajectory));
camera_poses_noisy = cell(1, length(t)); % 存储带噪声的相机位姿的元胞数组
camera_trajectory_noisy(:,1) = camera_trajectory(:,1); % 初始位姿不变
camera_poses_noisy{1} = camera_poses{1}; % 存储初始位姿

A_matrices = cell(1, length(t)-1); % 存储A矩阵的元胞数组
B_matrices = cell(1, length(t)-1); % 存储B矩阵的元胞数组

R_body_to_world_prev = eye(3); % 初始化前一时刻的车体旋转矩阵

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
B = T_cam_to_body * A * inv(T_cam_to_body);
B_matrices{i-1} = B;
    
    R_body_to_world_prev = R_body_to_world; % 更新前一时刻的车体旋转矩阵
end

%% 测试AX=XB

err_translation = []; % 存储平移误差
err_rotation = []; % 存储旋转误差

for i = 1:length(t)-1
    A = A_matrices{i};
    B = B_matrices{i};
    X = T_body_to_cam;
    
    % 计算AX和XB
    AX = A * X;
    XB = X * B;
    
    % 计算平移误差
    err_translation(i) = norm(AX(1:3,4) - XB(1:3,4));
    
    % 计算旋转误差
    R_AX = AX(1:3,1:3);
    R_XB = XB(1:3,1:3);
    err_rotation(i) = norm(R_AX - R_XB, 'fro'); % 使用矩阵的Frobenius范数计算旋转误差
end

% 输出最大平移误差和最大旋转误差
max_err_translation = max(err_translation)
max_err_rotation = max(err_rotation)



%% 绘制三个轨迹在同一个图中,并在特定位置绘制位姿坐标轴
figure;
plot3(x, y, z, 'b-', 'LineWidth', 2);
hold on;

if need_plot_no_noise  %不一定要plot原始数据
   plot3(camera_trajectory(1,:), camera_trajectory(2,:), camera_trajectory(3,:), 'r-', 'LineWidth', 2);
end

plot3(camera_trajectory_noisy(1,:), camera_trajectory_noisy(2,:), camera_trajectory_noisy(3,:), 'k-', 'LineWidth', 2);

% 在特定位置绘制位姿坐标轴
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
    
    % 绘制带噪声的位姿坐标轴
    T_noisy_cam_to_world = camera_poses_noisy{idx};
    R_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 1:3);
    t_noisy_cam_to_world = T_noisy_cam_to_world(1:3, 4);
    plotCoordinateFrame(R_noisy_cam_to_world, t_noisy_cam_to_world, axis_length);
end

title('车体中心轨迹、相机轨迹和带噪声的相机轨迹');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('车体中心轨迹', '带噪声的相机轨迹');
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