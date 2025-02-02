function [] = rls(selectedNoiseIndex)

% Choosing the right noise reference file according to the input coming
% from LabVIEW.
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

fs = 8000;

noisy_speech = load("noisySpeech.txt"); % Noisy signal data saved by LabVIEW
noise = load(selectedNoise); % Reference noise

Ts = 1/fs; % Sampling period
k = 1*fs-1; % Max sample for 1 second recording
t =(0:k)*Ts; % Time vector

M = 30; % Filter length

% If lamda is close to 1, there will be less fluctuations in the filter
% coefficients.
% When lamda is 1, we will have a growing window RLS algorithm  

lambda = 1; % Forgetting factor

% Small positive constant. Smaller delta values result in lesser noise.
delta = 0.01; 

lambdaInv = 1/lambda;
deltaInv = 1/delta;

N = length(noisy_speech);
w = zeros(M, 1); % Filter coefficients initialized
P = deltaInv*eye(M); % Inverse correlation matrix
output = zeros(N,1); 

% The for loop below is to adapt the filter coefficients according to the
% noise reference and apply this filter to the input signal.

for i=M:N
    
    % Getting the M length noise reference
    y = noise(i:-1:i - M + 1);
    % Estimated output signal is subtracted from the noisy speech.
    output(i) = noisy_speech(i) - w' * y;
    % Filter gain is determined
    k = (P * y) / (lambda + y' * P * y);
    % Inverse correlation matrix is updated.
    P = (P - k * y' * P) * lambdaInv;
    % Updating filter coefficents.
    w = w + k * output(i);

end

output = normalize(output,'range',[-1 1]);
% Writing the output to a text file for the LabVIEW to read the file later.
writematrix(output,"rlsOutput.txt");

end