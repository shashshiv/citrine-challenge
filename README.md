# citrine-challenge
This repository is made in response to submission for Citrine Informatics Challenge problem.

# Instructions
1. Visit https://github.com/shashshiv/citrine-challenge to check out the code and 
to download the repository git clone https://github.com/shashshiv/citrine-challenge.git.

2. I have developed the code using Matlab on Windows environment though you can also use 
Linux since most fucntions have been generalised for both.
Installation requirements include only installtion of Matlab version R2016a or higher.

3. Running script,
To run the code go to the folder citrine-challenge and run matlab either in gui or on terminal using command matlab,
then write the command in either matlab gui command line or terminal, 
Example
```
matlab
sampler('example.txt','examplesOutput\example_1000.txt',1000) 
```
where 'example.txt' is the input file path,'examplesOutput\example_1000.txt' is the output path and 1000 is the n_results
required by the program.
       
4. Output format, 
The output will be produced with the same name as described in output file path by user in commandline input.
The output file generated contains list of space delimited vectors each on new line.
Matlab gui commandline looks something like this,
Example
```
>> sampler('alloy.txt','examplesOutput\alloy_1000.txt',1000)
NOTE: Based on acceptance ratio Method 1 might timeout so shifting to Method 2!
Sampling Completed.
Time elasped for simulation is 299.136036 seconds
```
# Functions and Modules
Foldes:</br>
sampler.m - This is the main file containing all the modules that helps in generating samples using Latin Hypercibe sampling.</br>

examplesInput - contains test cases provided by citrine.</br>

examplesOutput - contains output for the test cases in format e.g. alloy_1000 for n_results =1000 for alloy input file.</br>

parseCheckInput -</br>
  1.parseInput: This function reads the input values from the text file and converts them to data structures.</br>
  2.checkTimeOut: Calculetes acceptance ratio for generating 1 feasible vector.</br>
  3.checkFeasiblePoint: Checks for the feasibility of example point provided on input file.</br>

parseConstraints -</br>
  1.acceptReject: This function applies the rejection algorithm to either accept or rejct based on constraints.</br>
  2.constraintExpressions: Converts constraints into array of char type which is later converted.</br>
  to matlab format mathematical expressions 

## Algorithm
The main code running all the modules is sampler.m that takes input arguments as the input file path, output file path and number of samples needed.
Then all the foldes specified are added to search path and precedence is given to user given paths over the existing paths. The outfile name and path are extracted for
saving the output vectors. Now parseInput function is utilized to read the input from a input text file and converts them to data structure allowed in matlab, 
since the provided citrine files for parsing the input were for python only I have created a set of functions that works for Matlab, next we parse the 
constraints into matlab expressions using function constraintExpressions that will convert the list of constraints into the matlab readable expressions.
Then a function checkFeasiblePoint checks for the feasibility of the example point and samples are generated based on Method-1 or Method-2. Method 1 is general Latin hypercube sampling using lhsdesign(n,p) which returns an n-by-p matrix containing a latin hypercube sample of n values on each of p variables, and acceptReject function makes sure that generated vectors follow all the given constraints. Though this method fails for two test cases i.e. alloy and formulaion due to timeout(which is 5min as required by citrine challenge), so to handle such situations where either the dimensionality of problem is too high or the case requires large amount of time I use mathod-2. So I use method-2 either when dimensanality is very high or the acceptance ratio for generated samples is very low, in theses case method-2 is used which starts with the given example point and utilizes Latin hypercube sampling over smaller number of dimensions than the total number of dimensions. I extreme case in order to reduce computation time I take only 1 dimension LHS and equal number of samples are distributed over every dimension where LHS is taken one at a time. Finally the outfile is saved in used defined path and the time elapsed is displayed in command line. 

# Submission
Shashank Pandey</br>
Graduate Research student</br>
Columbia University</br>
Department of Chemical Engineering</br>
Bishop Research Group</br>

# Contact Info
Contact using either sp3468@columbia.edu or shashankpandey50@gmail.com if there's any trouble running the code.
