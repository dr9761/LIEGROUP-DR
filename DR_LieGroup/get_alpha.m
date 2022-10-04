function [alpha] = get_alpha(b)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
alpha =sin(sqrt(dot(b,b)))/(sqrt(dot(b,b))) ;
end