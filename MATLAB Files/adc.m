function [] = adc(selectedNoiseIndex)

disp(selectedNoiseIndex);

switch selectedNoiseIndex
    case "0"
        selectedNoise = "drillSound.txt";
    case "1"
        selectedNoise = "fanNoise.txt";
    case "2"
        selectedNoise = "chainsawNoise.txt";
    otherwise 
        selectedNoise = "drillSound.txt";
end

disp(selectedNoise);

dt = 1 / 8000;

reference = load("reference.txt");
noise = load(selectedNoise);
data = reference + noise;

bits = 16;

partition = linspace(-1, 1, pow2(bits));

indx = quantiz(data, partition);

decimalToBinary = [];

d2b = dec2bin(indx, 16);
for i = 1 : length(d2b)
    for j = 1 : bits
        decimalToBinary(i,j) = str2double(d2b(i,j));
    end
end

decimalToBinary = reshape(decimalToBinary',1,128000)';

writematrix(decimalToBinary, "adc.txt");
end


