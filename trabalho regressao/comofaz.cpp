#include <iostream>
using namespace std;

int main(){
    float x, y;
    int n = 0;

    FILE* dados = fopen("entrada.txt", "r");

    // somatorias
    float somaX = 0, somaY = 0;
    float somaXY = 0, somaX2 = 0;

    // guardando entrada
    while(true){
        if(fscanf(dados, "%f %f", &x, &y) == EOF){
            fclose(dados);
            break;
        }
        
        somaX += x;
        somaY += y;
        somaXY += x*y;
        somaX2 += x*x;
        
        n++;
    }

    // coeficientes
    float coefA = (n*somaXY - somaX*somaY) / (n*somaX2 - somaX*somaX);
    float coefB = (somaY - coefA*somaX) / n;

    // Colocar em resultado.txt/criar
    FILE* dados_saida = fopen("resultado.txt", "a+");
    
    // Verifica quantas execuções teve no arquivo de saida
    int exec = 0;
    while(true){
        // veriais descartaveis
        int desc1;
        float desc2, desc3;
        exec++;
        
        if(fscanf(dados_saida, "Execução %d\n============\nCoeficiente a: %f\nCoeficienteb: %f\n============\n", &desc1, &desc2, &desc3) == EOF){
            break;
        }
    }

    // Enfia td nos arquivos
    fprintf(dados_saida, "Execução %d\n============\nCoeficiente a: %f\nCoeficienteb: %f\n============\n", exec, coefA, coefB);
    fclose(dados_saida);

    return 0;
}