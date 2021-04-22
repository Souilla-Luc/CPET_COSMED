
# CPET_Analysis (COSMED software)

Aims of this study are:

* To help health professional to report CPET Data in preprint medical report. To improve the        reliability of report data by programming language.
  
* To save data from all patient in protected and confidential database.
	
	CPET_analysis file grouping : 
	
	* `DAT` : CPET data extracted from Cosmed software. Be careful, it has to be **xls. file**
	* `PRG` : Main script and function include in the script 
      + `getValue.sci`, `getInformation.sci` = find and read values in xls.file
      + `PasteValue.sci`, `PasteInformation.sci` = Paste values in output file (medical report,and output data base)
      
	* `RES` : Graphics and medical report of patient generated by script.
	       `database_output.csv`,it is practical way to make a database of your population.
	      
## Usage

* Clone or download the repository
* On your computer, open `main.sce` then run the script with F5 or click the button with grey triangle
	  
## Notes 
	  
* Install [Scilab](https://www.scilab.org) scilab on your computer, For mac Users: click [here](https://www.utc.fr/~mottelet/scilab_for_macOS.html)

* Make sure that CPET software is **COSMED**

* Please, convert `.xlsx` generated by COSMED in `.xls`, and drag it in `DAT`

* Do not modify the names and organisation of the directories.
  The `DAT`+`PRG`+`RES` structure is expected when initialising in `InitTRT.sce`
  
* In DOC file, you can find more details in`read_me_longer.pdf`. Once you have read it , you could use script more easily.

* I made a youtube tutorial, click [[here]](https://youtu.be/AKPK5kO6MOo)      
