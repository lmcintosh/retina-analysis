function [kernel] = linearKernel(frequency,phase,variance)
% linearKernel generates the linear filter of an LN model typical of the retina
% This filter is the dot product of a sinusoid and a gaussian pdf.
% INPUTS: frequency (of the sinusoid), phase (of the sinusoid), variance (of the gaussian)
% OUTPUTS: row vector of the kernel
