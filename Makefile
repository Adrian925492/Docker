all:
	$(CXX) -g main.cpp -o dockerExample.exe

clean:
	del -f dockerExample.exe