#include <iostream>
using namespace std;

int main(){
    int lista[] = {6, 8, 4, 2, 8, 1, 0};
    int tamanho = sizeof(lista)/sizeof(lista[0]);

    for(int j = 0; j < tamanho; j++){
        for(int i = 0; i < tamanho-1; i++){
            if(lista[i] > lista[i+1]){
                int temp = lista[i];
                lista[i] = lista[i+1];
                lista[i+1] = temp;
            }
        }
    }

    for(int i = 0; i < tamanho; i++){
        cout << lista[i] << " ";
    }
    cout << endl;

    return 0;
}