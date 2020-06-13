#!/bin/bash

g++ -g relay_selection.cpp -o rs.out
g++ -g channel_assignment.cpp -o cha.out
g++ -g power_control.cpp -o pc.out

dr=100;
cr=100;
tsir=1;
max_power=2;
noise=0.0000000001;

for k in `seq 2 5`;
do
     	for n in `seq 5 5`;
	do	
		echo "k=$k,n=$n" >> R03_cpp_cen_SoP.txt
		echo "k=$k,n=$n" >> R03_cpp_cen_SoS.txt

		for itr in `seq 1 10`;
		do	
			echo "k=$k,n=$n,iteration=$itr"	
			#sleep 1
			
			if [ $itr -eq 50 ]
			then
				sed -n "/^n=$n,iteration=50/,/^n=$(($n + 1)),iteration=1/p" R01_LoN.txt | awk '/^x/'|sed 's/x\[0\] = 5000;//g'|sed '/^\s*$/d'|sed 's/;//g'|sed 's/x//g'|sed 's/ = / /g'|sed 's/\[//g'|sed 's/\]//g'>I01_x.txt
				echo "$(($n + 1)) 5000" >> I01_x.txt
				sed -n "/^n=$n,iteration=50/,/^n=$(($n + 1)),iteration=1/p" R01_LoN.txt | awk '/^y/'|sed 's/y\[0\] = 5000;//g'|sed '/^\s*$/d'|sed 's/;//g'|sed 's/y//g'|sed 's/ = / /g'|sed 's/\[//g'|sed 's/\]//g'>I01_y.txt
				echo "$(($n + 1)) 5000" >> I01_y.txt
			else
				sed -n "/^n=$n,iteration=$itr$/,/^n=$n,iteration=$(($itr + 1))$/p" R01_LoN.txt | awk '/^x/'|sed 's/x\[0\] = 5000;//g'|sed '/^\s*$/d'|sed 's/;//g'|sed 's/x//g'|sed 's/ = / /g'|sed 's/\[//g'|sed 's/\]//g'>I01_x.txt
			echo "$(($n + 1)) 5000" >> I01_x.txt
				sed -n "/^n=$n,iteration=$itr$/,/^n=$n,iteration=$(($itr + 1))$/p" R01_LoN.txt | awk '/^y/'|sed 's/y\[0\] = 5000;//g'|sed '/^\s*$/d'|sed 's/;//g'|sed 's/y//g'|sed 's/ = / /g'|sed 's/\[//g'|sed 's/\]//g'>I01_y.txt
			echo "$(($n + 1)) 5000" >> I01_y.txt
			fi

			./rs.out $n $k $dr $cr
			./cha.out $n $k $tsir $noise $max_power
			./pc.out $n $k $tsir $noise $max_power

			rm R01_NN.txt
			rm R01_NoH.txt
			rm R02_ach.txt
			rm I01_x.txt
			rm I01_y.txt
		done 
	done    
done 

rm rs.out
rm pc.out
rm cha.out
