iterations = 50;
actualVar = zeros(iterations,1);
time = round(linspace(10e2,10e6,iterations));
expectedVar = linspace(1,10,iterations);

for i = 1:iterations
    process = wiener(0,0,expectedVar(i),time(i),0);
    actualVar(i) = var(process);
end

figure; plot(expectedVar,'r-'), hold on, plot(actualVar,'k.')