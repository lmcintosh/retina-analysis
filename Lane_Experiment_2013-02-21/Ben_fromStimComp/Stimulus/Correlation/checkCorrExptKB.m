function ex = checkCorrExptKB(ex)
%
% (c) bnaecker@stanford.edu 9 Jan 2012

[ex.kb(1).keyIsDown, ex.kb(1).secs, ex.kb(1).keyCode] = KbCheck(-1);

% Do stuff
% if kb.keyIsDown
% end