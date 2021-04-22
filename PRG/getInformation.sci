// function to read a character string of interest
// Logic : we need to know the measure of interest, to find corresponding index 
// measure = what we want to read (could be a matrix)
// namefile= Matrix of character string
// apply "getInformation" function
//endfunction

function [value]=getInformation(measure,namefile)
    for i=1:size(measure,"c"); 
    [irowname,icolname]=find(namefile == measure(i));
       icolname=icolname+1; // icolname= label of interest , icolname+1= value correspondng to the label

       //done: get value with correct index
       value(i)=namefile(irowname,icolname);
       end
   endfunction
