function [p,r] = calcPandR(confmat)
    p = precision(confmat);
    r = recall(confmat);
end
function y = precision(M)
  y = diag(M) ./ sum(M,2);
  y
end

function y = recall(M)
  y = diag(M) ./ sum(M,1)';
  y
end