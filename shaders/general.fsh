function grid_frag(){ return `

    #include <packing>

    varying vec2 xy;
    uniform sampler2D tTexture;
    uniform float highlight;

    //IMPORT_FRAGEXT//
    vec3 hsv2rgb(vec3 c){
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }
    vec3 hlfunc(vec3 c){
        // return fract(c+0.5);
        vec3 t = rgb2hsv(c);
        //t.z = fract(t.z-0.1);
        t.z = clamp(t.z+0.3, 0., 1.);
        return hsv2rgb(t);
    }

    void main() {
        vec4 targetColor = texture2D( tTexture, xy );
        vec4 targetColor2 = vec4(hlfunc(targetColor.xyz), 1.0);
        gl_FragColor = mix(targetColor, targetColor2, highlight);
    }

`}

function grid_vert(){ return `

    varying vec2 xy;

    void main() {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
        xy = (gl_Position.xy+1.0) / 2.0;
    }

`}

function post_frag(){ return `

    #include <packing>

    varying vec2 vUv;
    uniform sampler2D tTexture;
    uniform float dx;

    void main() {
        float d = dx * 100.0;
        vec4 targetColor = texture2D( tTexture, vUv );
        gl_FragColor = targetColor;
    }

`}

function post_vert(){ return `

    varying vec2 vUv;

    void main() {
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }

`}

function vert(){ return `

    // varying vec2 v;

    void main() {
        vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );
        gl_Position = projectionMatrix * mvPosition;
        // v = position.xy;
    }

`}

