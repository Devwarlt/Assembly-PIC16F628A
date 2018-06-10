function [output] = algorithm2(arg1, arg2, arg3)
% The 'conv' function similar algorithm
% Author: Nádio Dib

% Enable / disable debug log:
debug = true;

% Save input parameters into arrays 'x', 'a' and 'b':
x = arg1;
a = arg2;
b = arg3;

% Keep initial data from arrays 'a' and 'b':
a_ = a;
b_ = b;

% Measure for array 'y' length:
n = length(x);

% Build an array with 1 line and 'n' columns:
y = zeros(1, n);

% Refactor array 'a':
if length(a) ~= n
    a(end + 1 : numel(y)) = 0;
end

% Refactor array 'b':
if length(b) ~= n
    b(end + 1 : numel(y)) = 0;
end

% Process array 'y':
for m = 1 : n
    y(m) = a(m);
end

if debug == true
    fprintf("Input parameters:\n");
    fprintf("\t# 'x': [" + num2str(x) + "]\n");
    fprintf("\t# 'a': [" + num2str(a_) + "]\n");
    fprintf("\t# 'b': [" + num2str(b_) + "]\n\n");
    fprintf("Resized arrays:\n");
    fprintf("\t# resized 'a': [" + num2str(a) + "]\n");
    fprintf("\t# resized 'b': [" + num2str(b) + "]\n\n");
    fprintf("\t# 'y': [" + num2str(y) + "]\n");
else
    output = y;
    disp(output);
end
end
