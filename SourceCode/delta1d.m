function Deltas = delta1d(arguments)
    arguments
        arguments.pixelIndex (1,:) {mustBeNumeric};
        arguments.displacement (1,:) {mustBeNumeric};
        arguments.g (1,:) {mustBeNumeric};
        arguments.g_prime (1,:) {mustBeNumeric};
    end
    if(length(arguments.g) ~= length(arguments.g_prime))
        error("Input Array Dimension Mismatch!!!");
    elseif(length(arguments.g) < length(arguments.g_prime))
        error("Displacement Array Dimension Mismatch!!!");
    end
    Deltas = zeros(1,length(arguments.displacement));
    for i=(1:length(arguments.displacement))
        try
            Deltas(i) = abs(arguments.g(arguments.pixelIndex) - arguments.g_prime(arguments.pixelIndex + arguments.displacement(i)));
        catch
            Deltas(i) = nan;
        end
    end
end