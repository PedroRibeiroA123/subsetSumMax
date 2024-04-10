#include <ctime>
#include <ratio>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <algorithm>
#include <vector>
using namespace std;

int generate_target(int n);
vector<int> generate_rand_vec(int n);
vector<int> trim(vector<int> L, float delta);
int exact_subset_sum(vector<int> S,int n, int t);
int approx_subset_sum(vector<int> S, int n, int t, float epsilon);

int main(){
	FILE *exact_f, *approx_f, *error_f;
	exact_f = fopen("exact.csv","w");
	approx_f = fopen("approx.csv", "w");
	error_f = fopen("error.csv", "w");

	clock_t start, end;
	int t = 0, exact = 0, approx = 0;

	fprintf(exact_f,"tamanho;valor;tempo\n");
	fprintf(approx_f,"tamanho;valor;tempo\n");
	fprintf(error_f, "tamanho;exact;approx\n");
	for(int i = 50; i<2500; i+=50){
		vector<int> S = generate_rand_vec(i);
		t = generate_target(i);

		start = clock();
		approx = approx_subset_sum(S, i, t, 0.4);
		end = clock();
		fprintf(approx_f,"%d;%d;%lf\n", i, approx, (double)(end-start)/CLOCKS_PER_SEC);

		start = clock();
		exact = exact_subset_sum(S, i, t);
		end = clock();
		fprintf(exact_f,"%d;%d;%lf\n", i, exact, (double)(end-start)/CLOCKS_PER_SEC);
		fprintf(error_f,"%d;%d;%d\n",i,exact,approx);
	}
	fclose(exact_f);
	fclose(approx_f);
	fclose(error_f);
	return 0;
}

int generate_target(int n){
	srand(time(NULL));
	return rand() % (n + 1) + 4 * n;
}

vector<int> generate_rand_vec(int n){
	srand(time(NULL));
	vector<int>S(n);
	for(int i = 0; i < n; i++){
		S[i] = 1 + rand()%(3*n+1);
	}
	return S;	
}

vector<int> trim(vector<int> L, float delta){	
	vector<int> l;
	int last = L[0];
	int m = L.size();
	l.push_back(L[0]);

	for(int i = 1; i < m; i++){
		if(L[i] > last*(1+delta)){
			l.push_back(L[i]);
			last = L[i];
		}
	}

	return l;
}

int approx_subset_sum(vector<int> S, int n, int t, float epsilon){
	vector<vector<int>> L(n);
	float delta = epsilon/(2*n);
	L[0].push_back(0);
	int valor = 0;
	
	for(int i = 1; i < n; i++){
		// adding S[i] to all positions of L[i-1]
		valor = S[i];
		vector<int> modified(L[i-1].size());
		transform(L[i-1].begin(), L[i-1].end(), modified.begin(), [valor](int elemento) { return elemento + valor; });

		// creating L[i] and merging L[i-1] e L[i-1]+S[i]: 
		L[i] = vector<int>(L[i-1].size()*2);
		merge(L[i-1].begin(), L[i-1].end(), modified.begin(), modified.end(), L[i].begin());
		L[i].erase(unique(L[i].begin(), L[i].end()), L[i].end());
		
		// trim:
		L[i] = trim(L[i], delta);

		// removing from L[i] every element greater than t:
		L[i].erase(std::remove_if(L[i].begin(), L[i].end(), [t](int elemento) { return elemento > t; }), L[i].end());
	}
	return L.back().back();
}

int exact_subset_sum(vector<int> S,int n, int t){
	vector<vector<int>> L(n);
	L[0].push_back(0);
	int valor = 0;

	for(int i = 1; i<n; i++){
		// adding S[i] to all positions of L[i-1]
		valor = S[i];
		vector<int> modified(L[i-1].size());
		transform(L[i-1].begin(), L[i-1].end(), modified.begin(), [valor](int elemento) { return elemento + valor; });

		// creating L[i] and merging L[i-1] e L[i-1]+S[i]: 
		L[i] = vector<int>(L[i-1].size()*2);
		merge(L[i-1].begin(), L[i-1].end(), modified.begin(), modified.end(), L[i].begin());
		L[i].erase(unique(L[i].begin(), L[i].end()), L[i].end());
		
		// removing from L[i] every element greater than t:
		L[i].erase(std::remove_if(L[i].begin(), L[i].end(), [t](int elemento) { return elemento > t; }), L[i].end());
	}
	return L.back().back();
}
