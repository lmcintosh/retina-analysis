function [thresholdVector] = nonlinearity(point,slope,resolution)
% nonlinearity generates a point nonlinearity used for thresholding in the LN model typical of the retina.
% INPUTS: point (the index, 1:resolution, at which the threshold begins), slope (the slope of the nonlinearity), resolution (number of samples in output vector)
% OUTPUT: thresholdVector (a row vector of the nonlinearity)

thresholdVector = zeros(1,resolution);
secondLine = slope*linspace(0,1,resolution+1-point);

thresholdVector(point:resolution) = secondLine;
