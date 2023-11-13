function Costs = Cost2D(arguments)
    arguments
        arguments.inputArray1 (:,:) {mustBeNumeric};
        arguments.inputArray2 (:,:) {mustBeNumeric};
        arguments.displacement (:,:) {mustBeNumeric};
    end
    if(any(size(arguments.inputArray1) ~= size(arguments.inputArray2)))
        error("Input Array Dimension Mismatch!!!");
    elseif(any(size(arguments.inputArray1) < size(arguments.displacement)))
        error("Displacement Array Dimension Mismatch!!!");
    end
    Costs = zeros(size(arguments.displacement));
    for i=(1:size(arguments.displacement,1))
        for j=(1:size(arguments.displacement,2))
            try
                Costs(i,j) = arguments.inputArray1(i,j) - arguments.inputArray2(i,j + arguments.displacement(i,j));
            catch
                Costs(i,j) = nan;
            end
        end
    end
end