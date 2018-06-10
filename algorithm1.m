function [output] = algorithm1(arg1, arg2)
% The 'conv' function similar algorithm
% Author: Nádio Dib

% Enable / disable debug log:
debug = true;

% Save input parameters into arrays 'x' and 'h':
x = arg1;
h = arg2;

% Keep initial data from arrays 'x' and 'h':
x_ = x;
h_ = h;

% Measure for array 'y' length:
n = length(x) + length(h) - 1;

% Build an array with 1 line and 'n' columns:
y = zeros(1, n);

% Refactor array 'x':
if length(x) ~= n
    x(end + 1 : numel(y)) = 0;
end

% Refactor array 'h':
if length(h) ~= n
    h(end + 1 : numel(y)) = 0;
end

% Get properly array size for 'x' shift arrays:
shift_x = cell(n, 1);

% Keep beginning value from array 'x':
shift_x{1} = x;

% Keep all shift arrays from array 'x':
for m = 1 : n - 1
    shift_x{m + 1} = [zeros(1, m) x(1 : end - m)];
end

% Get properly array size for 'y':
j = cell(n, 1);

% Do the convolution between arrays 'x' and 'h':
for k = 1 : n
    j{k} = h(1, k) .* shift_x{k};
end

% Keep the convolution into single array 'y':
for h = 1 : n
    if h == 1
        y = cell2mat(j(h));
    else
        y = y + cell2mat(j(h));
    end
end

% Output (debug only):
if debug == true
    fprintf("Input parameters:\n");
    fprintf("\t# 'x': [" + num2str(x_) + "]\n");
    fprintf("\t# 'x' length: " + num2str(length(x_)) + "\n");
    fprintf("\t# 'h': [" + num2str(h) + "]\n");
    fprintf("\t# 'h' length: " + num2str(length(h_)) + "\n\n");
    fprintf("Resized arrays:\n");
    fprintf("\t# resized 'x': [" + num2str(x) + "]");
    fprintf("\t# resized 'x' length: " + num2str(length(x)) + "\n");
    fprintf("\t# resized 'h': [" + num2str(h) + "]");
    fprintf("\t# resized 'h' length: " + num2str(length(h)) + "\n\n");
    fprintf("\t# 'y': [" + num2str(y) + "]\n");
    fprintf("\t# 'y' length: " + num2str(n) + "\n\n");
    fprintf("Using function 'conv':\n");
    fprintf("\t# 'y' = 'x' * 'h' = [" + num2str(conv(x_, h_)) + "]\n");
else
    output = y;
    disp(output);
end
end
