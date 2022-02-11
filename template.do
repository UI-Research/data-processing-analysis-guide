*********************************
*	[File Title]				*
*	[Author(s)]					*
*	[DATE]						*
*********************************

/////Purpose - Prepare auto2 data for analysis/////

//install all necassary packages

//clear memory
clear

//Define the file directory (in this case we are using system data so we do not need to do this, but the command is shown in a comment below)

*cd "[file directory]"



/////Import data into Stata and save Stata datasets ///// (in this case, the data is already in a .dta format, but an example of how to load and save datsets in different formats is shown in comments below)

//load the stata dataset auto2
sysuse auto2.dta

//Examples
*import [filetype] "[filename]"
*save [filename], replace
*clear





/////CHECK DATA/////
//Does the population in the data match the target population for the study?
*visually inspect the dataset
br

//What is the missingness of the variables? 
//Do you understand what each of the variables represents? 
*view the variables, their types, formats, labels, and label values. 
describe

*view the number of observations and unique observations, and the mean, min, and max for each variables. Also shows labels for variable. String variables will display as "." for mean, min, and max. 
codebook, compact

//What unit of observation do you want? 
//Are there duplicates in the data? If so, how will you address them?
*check the unit of observations and check for duplicates (this confirms that there are no complete duplicates observations in the dataset and that there is one observation per make of car)
duplicates r
duplicates r make

//Will any observations need to be excluded or deleted?
*you can use a command like "keep if" and "drop if" to identify observations to keep or exclude (in this example we don't want cars that are "Peugeot" make)
tab make
drop if regex(make, "Peugeot")

//Do any of the files need to be merged / joined together? If so, are the files at the same unit? 
//Do any of the files need to be appended together? If so, are the files at the same unit? 
*In this case we only have one file, but if you have multiple files you can use append (when datasets cover the same variables for different groups of observations) and merge (when datasets cover the same group of observations with different variables) to join them as needed after confirming that they are at the same unit of observations




/////PROCESS DATA/////

//Is any other manipulation necessary for analysis (e.g., inflation adjusting)? (examples of data manipulation are shown below)

//convert weight from pounds to kilograms
replace weight = weight/2.2046
*update the variable label
label var weight "weight (kilograms)"

//gen variable year
gen year = 1978

//make a categorical variable from the price variable
sum price
*create a histogram with five bins to see what distribution will look like
hist price, bin(5)

gen price_cat = ""
replace price_cat = "<4500" if price < 4500
replace price_cat = "4500-5999" if price < 7000 & price >=4500
replace price_cat = "6000-7999" if price < 8000 & price >=6000
replace price_cat = "8000-9999" if price < 10000 & price >=8000
replace price_cat = "10000+" if price >=10000
tab price_cat, m

//clean make and model names

*separate out make (there are simpler ways to do this, see example for model (could use "model1" var), but this is a good command for data that is less clean)
tab make, m
rename make make_model

gen make = ""
replace make = "amc" if regex(make_model, "AMC")
replace make = "audi" if regexm(make_model, "Audi")
replace make = "bmw" if regexm(make_model, "BMW")
replace make = "buick" if regexm(make_model, "Buick")
replace make = "cadalac" if regexm(make_model, "Cad.")
replace make = "chevroelt" if regexm(make_model, "Chev.")
replace make = "datsun" if regexm(make_model, "Datsun")
replace make = "dodge" if regexm(make_model, "Dodge")
replace make = "fiat" if regexm(make_model, "Fiat")
replace make = "ford" if regexm(make_model, "Ford")
replace make = "honda" if regexm(make_model, "Honda")
replace make = "lincoln" if regexm(make_model, "Linc")
replace make = "mazda" if regexm(make_model, "Mazda")
replace make = "mercedes" if regexm(make_model, "Merc.")
replace make = "oldsmobile" if regexm(make_model, "Olds")
replace make = "plymouth" if regexm(make_model, "Plym.")
replace make = "pontiac" if regexm(make_model, "Pont.")
replace make = "renault" if regexm(make_model, "Renault")
replace make = "subaru" if regexm(make_model, "Subaru")
replace make = "toyota" if regexm(make_model, "Toyota")
replace make = "volx_wagon" if regexm(make_model, "VW")
replace make = "volvo" if regexm(make_model, "Volvo")
tab make, m

*separate out model
split make_model, gen(model)
gen model = model2 + " " + model3
drop model1 model2 model3
replace model = lower(model)

*check new variables
duplicates r make_model
duplicates r make model



//After processing the data, did you check the accuracy and quality of the data again?
*It is important to run checks on the dataset as you are processing and before you start analysis. below are some examples of checks that can be run. 
duplicates r
duplicates r make model

tab make, m
tab model, m

sum price
hist price


/////ANALYZE DATA/////

//Descriptive

sum price mpg rep78 headroom trunk weight length turn displacement gear_ratio foreign

tab price_cat

correlate mpg price weight


//Graphs (you can graph in stata but I recommend graphing in Excel or R for Urban formatting)

hist price

//Maps (this is not geographic data, R has Urban formatting for mapping)

//Modeling

reg mpg weight length gear_ratio

reg price mpg weight length gear_ratio


//Other analysis





/////SAVE FILE(s)/////

*save [filepathway/]auto_clean, replace
