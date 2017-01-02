Multi-Thread Apriori Application

This project focuses on maximimizing the Apriori data mining method by running the application through multiple
threads simultaneously. 

There is a sample retail data set, along with a debugging version of the program, a C version of the program which
is not multi-threaded and a CUDA version of the program which is multi-threaded.

  - Brief Overview of Apriori Algorithm - 

Algorithm for determining frequent item associations within a data set. Essentailly the user sets a support value which 
acts as the threshold value for what is considered significant or not. If an item set appears in a given data set with a
frequency larger than the support value it is considered to be significant and frequently occuring. The algorithn has six
main steps:

  1) Set the Support value for a given data set and the cardinality of each item set to 1 (this means at the beginning 
     each item set only contains one item)
  2) Determine the frequency value of each item set in the data set
  3) Invalidate item sets that have a frequency value lower than the threshold
  4) Increase the cardinality of the item sets by one and generate new items sets from the reamining valid items
  5) If any of the invalidated item sets from the previous step are a sub-set of the newly generated item sets, 
     invalidate the newly generated item set
  6) Repeat steps 2 - 5 until there are no longer any valid item sets
   
   *** The most frequently occuring item sets are the valid sets from the previous iteration***
   
   - Project Objective - 

Develop an application based on the Apriori algorithm and improve its running time through GPU programming. This project
specifically uses CUDA programming and utilizes the cores of CUDA compatible NVIDIA graphics cards to run the varies frequency
counting concurrently.
