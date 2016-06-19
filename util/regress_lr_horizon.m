function [left, right] = regress_lr_horizon(lr, width, height, base_xres, base_yres, Nbins, radius, distRange)

left = height/2 - lr(1)/base_yres*height;
right = height/2 - lr(2)/base_yres*height;