function Costs = Cost(arguments)
    arguments
        arguments.inputArray1 (1,:) {mustBeNumeric};
        arguments.inputArray2 (1,:) {mustBeNumeric};
        arguments.displacement (1,:) {mustBeNumeric};
    end
    if(length(arguments.inputArray1) ~= length(arguments.inputArray2))
        error("Input Array Dimension Mismatch!!!");
    elseif(length(arguments.inputArray1) < length(arguments.displacement))
        error("Displacement Array Dimension Mismatch!!!");
    end
    Costs = zeros(1,length(arguments.displacement));
    for i=(1:length(arguments.displacement))
        try
            Costs(i) = arguments.inputArray1(i) - arguments.inputArray2(i + arguments.displacement(i));
        catch
            Costs(i) = nan;
        end
    end
end