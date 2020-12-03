function M = normM(train,N)
M=zeros(N,N);
for i = 1:N;
    for j =1:N;
        M(i,j)=norm(train(i,:)-train(j,:));
    end
end
end