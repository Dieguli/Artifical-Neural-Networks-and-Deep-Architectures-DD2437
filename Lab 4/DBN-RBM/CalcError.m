% CalcRmse: calculate the rmse between predictions and OUTs
%
% [rmse AveErrNum] = CalcRmse( dbn, IN, OUT )
%
%
%Output parameters:
% rmse: the rmse between predictions and OUTs
% AveErrNum: average error number after binarization
%
%
%Input parameters:
% dbn: network
% IN: input data, where # of row is # of data and # of col is # of input features
% OUT: output data, where # of row is # of data and # of col is # of output labels
%
%
%Version: 20130727

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deep Neural Network:                                     %
%                                                          %
% Copyright (C) 2013 Masayuki Tanaka. All rights reserved. %
%                    mtanaka@ctrl.titech.ac.jp             %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rmse = CalcError( dbn, IN, OUT )
 out = v2h( dbn, IN );

 err = OUT - out;
 rmse = err; %sqrt( sum(err(:)) / numel(err) );
end