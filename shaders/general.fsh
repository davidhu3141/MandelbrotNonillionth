function post_frag(){ return `

    #include <packing>

    varying vec2 vUv;
    uniform sampler2D tTexture;

    void main() {
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

    void main() {
        vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );
        gl_Position = projectionMatrix * mvPosition;
    }

`}

