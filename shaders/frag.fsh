function frag(){ return `

    #define PI 3.1415926535897932384626433832795
    #define ITER 1000
    #define DIGIT 18000
    #define DIGITF 18000.
    #define N 9

    uniform int l[N];
    uniform int b[N];
    uniform int sx[N];
    uniform int sy[N];
    uniform vec2 iResolution;
    uniform int cc;

    //IMPORT_FRAGEXT//
    //IMPORT_COLOR//

    vec4 lerpColor(float a){
        a = a * 0.667;
        vec3 v = vec3(0.5, 0.5, 0.5) + vec3(0.5, 0.5, 0.5) * cos(2. * PI*(vec3(1., 1., 1.) *a + vec3(0., 0.1, 0.2)));
        return vec4(v,1.0);
        // return vec4(a,a,a, 1.0);
    }

    void HP_num(float a, inout int r[N]) {
        r[0] = a >= 0. ? 1 : -1;
        a = abs(a);
        for (int i=1; i<N; i++) {
            a = a * DIGITF;
            r[i] = int(a);
            a = fract(a);
        }
    }

    void HP_mul(int a[N], int b[N], out int r[N]) {
        
        r[0] = a[0] * b[0];
        r[1] = a[1] * b[1];
        r[2] = a[1] * b[2] + a[2] * b[1];
        r[3] = a[1] * b[3] + a[2] * b[2] + a[3] * b[1];
        r[4] = a[1] * b[4] + a[2] * b[3] + a[3] * b[2] + a[4] * b[1];
        r[5] = a[1] * b[5] + a[2] * b[4] + a[3] * b[3] + a[4] * b[2] + a[5] * b[1];
        r[6] = a[1] * b[6] + a[2] * b[5] + a[3] * b[4] + a[4] * b[3] + a[5] * b[2] + a[6] * b[1];
        r[7] = a[1] * b[7] + a[2] * b[6] + a[3] * b[5] + a[4] * b[4] + a[5] * b[2] + a[6] * b[2] + a[7] * b[1];
        r[8] = a[1] * b[8] + a[2] * b[7] + a[3] * b[6] + a[4] * b[5] + a[5] * b[2] + a[6] * b[3] + a[7] * b[2] + a[8] * b[1];
        /* MODIFY THIS WHEN N CHANGES */

        for (int i = 2; i < N; i++) {
            r[i] += (r[i - 1] % DIGIT) * DIGIT;
            r[i - 1] = r[i - 1] / DIGIT;
        }

        r[N - 1] = r[N - 1] / DIGIT;

        for (int i = N - 2; i >= 1; i--) {
            r[i] += r[i + 1] / DIGIT;
            r[i + 1] = r[i + 1] % DIGIT;
        }

    }

    void HP_plus(int a[N], int b[N], out int r[N]) {

        if (a[0] * b[0] >= 0) {

            r[0] = a[0] != 0 ? a[0] : b[0];
            r[N - 1] = a[N - 1] + b[N - 1];

            for (int i = N - 2; i >= 1; i--) {
                r[i] = a[i] + b[i] + r[i + 1] / DIGIT;
            }
            for (int i = 2; i < N; i++) {
                r[i] = r[i] % DIGIT;
            }

        } else {

            int abslarger = 3;

            // for (int i = 1; i < N; i++) {
            //     if (abslarger == 3) {
            //         if (a[i] > b[i]) abslarger = 1;
            //         if (a[i] < b[i]) abslarger = 2;
            //     }
            // }

            abslarger = 
                  a[1] != b[1] ? (a[1] > b[1] ? 1 : 2)
                : a[2] != b[2] ? (a[2] > b[2] ? 1 : 2)
                : a[3] != b[3] ? (a[3] > b[3] ? 1 : 2)
                : a[4] != b[4] ? (a[4] > b[4] ? 1 : 2)
                : a[5] != b[4] ? (a[4] > b[4] ? 1 : 2)
                : a[6] != b[4] ? (a[4] > b[4] ? 1 : 2)
                : a[7] != b[4] ? (a[4] > b[4] ? 1 : 2)
                : a[8] != b[4] ? (a[4] > b[4] ? 1 : 2)
                : 3;/* MODIFY THIS WHEN N CHANGES */

            if (abslarger == 3){
                HP_num(0.,r);
                return;   
            };

            int t[N];
            int u[N];

            if (abslarger == 1){
                t = a; u = b;
            } else {
                t = b; u = a;
            }

            for (int i = N - 1; i >= 2; i--) {
                if (t[i] < u[i]) {
                    t[i - 1] -= 1;
                    t[i] += DIGIT;
                }
                r[i] = t[i] - u[i];
            }
            r[1] = t[1] - u[1];
            r[0] = abslarger == 1 ? a[0] : b[0];
        }

    }

    float valfunc(){
        
        vec2 scr = gl_FragCoord.xy / iResolution.xy;
        int temp1[N];
        int temp2[N];
        int temp3[N];
        int two[N];
        int ar[N];
        int ai[N];
        int zr[N];
        int zi[N];

        HP_num(2., two);
        HP_num(scr.x, temp1);
        HP_num(scr.y, temp2);
        HP_mul(sx, temp1, temp1);
        HP_plus(l, temp1, ar);
        HP_mul(sy, temp2, temp2);
        HP_plus(b, temp2, ai);
        zr = ar;
        zi = ai;

        float vsq;
        vsq = length(vec2(float(zr[1])/DIGITF, float(zi[1])/DIGITF));
        vsq = vsq * vsq;
        if (256.*vsq*vsq - 96.*vsq + 32./DIGITF*float(zr[1])*float(zr[0]) < 3.) 
            return float(ITER);
        
        for(int i=0; i<ITER; i++){      

            HP_mul(zr, zr, temp1);
            HP_mul(zi, zi, temp2);
            temp2[0] = -temp2[0];

            HP_mul(two, zi, zi);
            HP_mul(zr, zi, zi);

            // HP_plus(temp1, temp2, temp3)
            // HP_plus(ar, temp3, zr);
            if (ar[0] > 0) {
                HP_plus(temp1, ar, temp3);
                HP_plus(temp2, temp3, zr);
            } else {
                HP_plus(temp2, ar, temp3);
                HP_plus(temp1, temp3, zr);
            }

            HP_plus(ai, zi, zi);

            vsq = length(vec2(float(zr[1])/DIGITF, float(zi[1])/DIGITF));
            if(vsq > 2.001){
                return float(i);
            }

        }
        return float(ITER);
    }

    void main() {
        float cl = log(float(ITER)-float(cc)*0.5);
        gl_FragColor = lerpColor(clamp( log(valfunc()-float(cc)*0.5)/cl, 0.0, 1.0 ));
    }

`}

