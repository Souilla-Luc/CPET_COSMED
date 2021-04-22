// function to read a value of interest
// Logic : we need to know the line and the column to read 
// measure = what we want to read (could be a character matrix)
// timeOfMeasure = when we want the measure 
// apply "getValue" function
//endfunction

function val = getValue(Valsheet, measure, timeOfMeasure) 

    for i=1:size(measure,'c') // i: 1: number of column in "measure" matrix
        iLineMeasure = find(Labels == measure(i));// get the line of measure in "Labels"

        if iLineMeasure==[]then 
            val(i)=[]// If one variable wasn't measured during CPET, we return the value as empty matrix 
            
        else 
            // get the corresponding column names : 
            // get the lines of parametres 
            iLineColNames = find(Labels(1:iLineMeasure) == "Paramètre");
            // Keep only the last line, correponding to the value 
            iLineColNames = iLineColNames($); 

            // get the column of timeOfMeasure (Warm-up, VAT,Max)
            iColTime = find(Str_res(iLineColNames,:) == timeOfMeasure);

            // done : return the value / pick the value in Valsheet 
            val(i) = Valsheet(iLineMeasure, iColTime); 
        end
    end
endfunction
