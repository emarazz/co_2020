function sim = gaussianKernel(x1, x2, sigma)
    N = length(x1);
    sim = zeros(N,N);
    for i = 1 : N
        for j = 1 : N
            sim(i,j) = exp(-abs(x1(i)-x2(j))^2/(2*sigma));
        end
    end
end

