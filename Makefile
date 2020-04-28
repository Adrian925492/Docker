CXX := i686-w64-mingw32-g++

all:
	$(CXX) -g main.cpp -o dockerExample.exe

clean:
	rm -f dockerExample.exe