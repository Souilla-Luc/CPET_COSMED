// function to paste a value of interest in DataBase
// Logic : we need to know the line and the column to read, and the value to paste
// namefile= Matrix where we paste the data (Ex: DataBase)
// measure = What we want to read (could be a character matrix - line 1 of namefile)
// timeOfMeasure = when we want the measure (line 2 of namefile)
// value= Values that we picked before by GetValue function (could be a matrix of double)
// apply "PasteValue" function
// endfunction

function [namefile]=PasteValue(namefile,value,measure,timeOfMeasure)

    for i=1: size(measure,'c') // i: 1 to number of column in "measure" matrix
        
        ILabel=find(namefile(1,:)~=""); // get matrix without empty cells labels
     
        Begin=find(namefile(1,:)== measure(i));  
        iLabelBegin= find(ILabel==Begin);// get index colum of measure of interest 
        
        iLabelEnd= iLabelBegin+1; //End :get index column +1 
        End= ILabel(1,iLabelEnd); // Find End index in ILabel matrix
        End= End-1; // End index correspond to the next index variable, 
        // So End-1 select only colums of interested measure (even if there are empty cells into it)
        
        iTimesMeasure=find(namefile(2,Begin:End)==timeOfMeasure); 
        // Get index time of measure in data range of measure  
        // Datarange is created = | variable of interest until next variable | 
        // 1st: Get Begin index in this datarange (1st line of name file)
        // 2nd: Get Time of measure in this data range (2nd line of name file)
       
        icolPaste=Begin+(iTimesMeasure-1);
        // iTimeMeasure - 1 (Make sense : There are always 3 intervals between 4 values)
        ilinPaste= 3; // Paste value in line 3 of namefile
        
        // done : Paste the value in name file 
        namefile(ilinPaste,icolPaste)= string(value(i))
    end
endfunction
