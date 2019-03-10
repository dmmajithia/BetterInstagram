# converts unix time to a matching RGB color string, depending on the hour of day
import time

def getMoodfromTime(ntime=int(time.time())):
	nhour = time.strftime("%H", time.localtime(ntime))
	moodmapping = {}
	for i in range(24):
		moodmapping[i] = str(255-10*i) + " 70 70"
	return(moodmapping[int(nhour)])

def testMood():
	the_hr = getMoodfromTime()
	print(the_hr)


if __name__ == '__main__':
	testMood()

#  HOUR 07 - HOUR 19 - LIGHT
# 	7: 255
# 	8: 245
# 	9: 235
# 	10: 225
#
# # HOUR 20 - HOUR 06 - DARK
# 	1: max
# 	2: max-10
# 	3: max-20
# 	4: max-30
#