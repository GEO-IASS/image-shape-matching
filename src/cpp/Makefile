all: intersectmesh

intersectmesh: bbox.o bvhtreenode.o triangle.o vector3.o intersectmesh.o 
	g++ bbox.o bvhtreenode.o triangle.o vector3.o intersectmesh.o -o intersectmesh

intersectmesh.o: intersectmesh.cc 
	g++ -c -Wall -O2 intersectmesh.cc

bbox.o: bbox.cc 
	g++ -c -Wall -O2 bbox.cc

bvhtreenode.o: bvhtreenode.cc 
	g++ -c -Wall -O2 bvhtreenode.cc

triangle.o: triangle.cc 
	g++ -c -Wall -O2 triangle.cc

vector3.o: vector3.cc 
	g++ -c -Wall -O2 vector3.cc

clean:
	rm -rf *o intersectmesh
