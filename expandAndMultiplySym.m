% A_new * C == A*B
% B的向量的内容比C更少一些。
% A一般是常数  
% B是不完整的，比如q0q1 q0^2
% C是完整的变量 q0^2 q1^2 q0q1



function A_new = expandAndMultiplySym(A, B, C)
    % 验证B是否为C的子集
    assert(all(ismember(B, C)), '所有B中的元素必须在C中存在');
    
    % 初始化A_new为零向量，长度与C相同，类型为sym
    A_new = sym(zeros(size(C)));
    
    % 遍历B中的每个元素
    for i = 1:length(B)
        % 查找B(i)在C中的位置
        indexInC = find(ismember(C, B(i)));
        % 如果在C中找不到B(i)对应的元素，则报错
        if isempty(indexInC)
            error('元素B(%d)在C中没有找到对应的位置', i);
        end

        % 如果找到了，将A(i)的值复制到A_new中对应的位置
        A_new(indexInC) = A(i);
    end
end