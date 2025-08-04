#include <iostream>
using namespace std;

int main(){
    float x[100], y[100];
    int n = 0;

    // guardando entrada
    while(true){
    cin >> x[n] >> y[n];
    if (x[n] == 0 && y[n] == 0) break;
    n++;
    }

    // somatórias
    float somaX = 0, somaY = 0;
    float somaXY = 0, somaX2 = 0;

    for(int i = 0; i < n; i++){
        somaX += x[i];
        somaY += y[i];
        somaXY += x[i]*y[i];
        somaX2 += x[i]*x[i];
    }

    // coeficientes
    float coefA = (n*somaXY - somaX*somaY) / (n*somaX2 - somaX*somaX);
    float coefB = (somaY - coefA*somaX) / n;

    cout << "Coeficiente A: " << coefA << endl;
    cout << "Coeficiente B: " << coefB << endl;

    return 0;
}