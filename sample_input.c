#include<stdio.h>
#include<string.h>

int startFunc() {
    /* 
        This is our sample
        multiline comment
    */
    // This is our sample single line comment

    int a;
    int x=1;
    int y=2;
    int z=3;
    x=3;
    y=10;
    z=5;

    if(x>5) {
        for(int k=0; k<10; k++) {
            y = x+3;
            print("Hello!");
        }
    } else {
        int idx = 1;
    }

    for(int i=0; i<10; i++) {
        print("Hello Himal!");
        scan("%d", &x);

        if (x>5) {
            print("Hi");
        }
        
        for(int j=0; j<z; j++) {
            a=1;
        }
    } 
    return 1;
}