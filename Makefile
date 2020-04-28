all:
	$(CXX) main.cpp -o dockerExample.exe

clean:
	del -f dockerExample.exe