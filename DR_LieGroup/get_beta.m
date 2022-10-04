function [beta] = get_beta(b)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
beta = 2*(1-cos((sqrt(dot(b,b)))))/(dot(b,b));
end