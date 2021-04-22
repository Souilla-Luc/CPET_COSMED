// function to paste a value of interest in DataBase
// Logic : we need to know measure and value of this label,then we paste in "namefile"
// namefile = where we paste the data (Ex: DataBase)
// measure = What we want to read in namefile(could be a character matrix)
// value = Values that we picked before by getInformation function (could be a matrix of double)
// apply "PasteInformation" function
// endfunction

function [namefile]=PasteInformation(namefile,value,measure)
    for i =1:size(measure,'c') // i: 1 to number of column 
        icolumn=find(namefile(1,:)== measure(i)); // index column corresponding to information label
        irows= 3; // paste value on third line of namefile (Data Base)
          // done : Paste the value in name file 
        namefile(irows,icolumn)= string(value(i)); 
    end
endfunction
