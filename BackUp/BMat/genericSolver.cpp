#include <iostream>
#include <string>
#include <vector>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define MAXVARS 10
#define RANGE 2

using namespace std;

string decode_str(string text,float vars[MAXVARS]) {
	int size = text.size();
	string decoded = "";
	int keep = 0;
	for (int i = 0,j=0; i < size; i++) {
		if (text.at(i) != '_' && j == 0) {
			continue;
		}
		if (text.at(i) != '_' && j != 0) {
			decoded.append(text.substr(keep,i-j-keep));
			decoded.append(to_string(vars[j-1]));
			cout << "I: " << i << "\nJ: " << j << "\nKEEP: " << keep << "\n";
			keep = i;
			j = 0;
		}
		if (text.at(i) == '_') {
			j++;
		}
	}
	decoded.append(text.substr(keep,size));
	cout << "DEBUG: " << decoded << "\n";
	return decoded;
}

void calculate_vars(float pre_vars[MAXVARS][RANGE],float* ret) {
	for (int i = 0; i < MAXVARS; i++) {
		int mtplexer = rand()%2;
		int value = pre_vars[i][0];
		int centro = (int)pre_vars[i][1];
		if (mtplexer == 0) {
			mtplexer = -1;
		}
		if (centro < 2) {
			centro = 2;
		}
		value += rand()%(centro)*mtplexer;
		ret[i] = value;
		cout << "DEBUG LOG: " << ret[i] << "\n";
	}
}

int main() {
	srand(time(NULL));
	string teste = "Olá, eu gosto de fazer ______ _________.";
	float vars_teste[MAXVARS] = {1,2,3,4,5,6,7,8,9,10};
	float gen_vars[3][RANGE] = {{1,2},{2,3},{4,5}};
	float* ret = (float*)malloc(sizeof(float)*MAXVARS);
	decode_str(teste,vars_teste);
	calculate_vars(gen_vars,ret);
	free(ret);
	return 0;
}