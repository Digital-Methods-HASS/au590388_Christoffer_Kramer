for datafile in "$@"
do 
	echo $datfile
	bash goostats $datafile stats-$datafile
done

