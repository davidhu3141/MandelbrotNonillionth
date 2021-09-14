var HP = function () {

    const N = 7;
    const DIGIT = 18000;

    var num = function (a) {

        var r = Array(N);
        r[0] = a >= 0 ? 1 : -1;

        a = Math.abs(a);
        r[1] = a * DIGIT;

        for (var i = 2; i < N; i++) {
            r[i] = (r[i - 1] - Math.floor(r[i - 1])) * DIGIT;
        }

        for (var i = 1; i < N; i++) {
            r[i] = parseInt(r[i]);
        }

        return r;
    }

    var mul = function (a, b) {

        var r = Array(N);
        r[0] = a[0] * b[0];
        for (var i = 1; i < N; i++) {
            var sum = 0
            for (var j = 1; j < i + 1; j++) {
                sum += a[j] * b[i + 1 - j];
            }
            r[i] = sum;
        }

        for (var i = 2; i < N; i++) {
            r[i] += (r[i - 1] % DIGIT) * DIGIT;
            r[i - 1] = parseInt(r[i - 1] / DIGIT);
        }

        r[N - 1] = parseInt(r[N - 1] / DIGIT);

        for (var i = N - 2; i >= 1; i--) {
            r[i] += parseInt(r[i + 1] / DIGIT);
            r[i + 1] = r[i + 1] % DIGIT;
        }

        return r;
    }

    var plus = function (a, b) {

        var r = Array(N);
        r[0] = 1;

        if (a[0] * b[0] >= 0) {

            r[0] = a[0] != 0 ? a[0] : b[0];
            r[N - 1] = a[N - 1] + b[N - 1];
            for (var i = N - 2; i >= 1; i--) {
                r[i] = a[i] + b[i] + parseInt(r[i + 1] / DIGIT)
            }
            for (var i = 2; i < N; i++) {
                r[i] = r[i] % DIGIT;
            }

        } else {

            var abslarger = 3;
            for (var i = 1; i < N; i++) {
                if (abslarger == 3) {
                    if (a[i] > b[i]) abslarger = 1;
                    if (a[i] < b[i]) abslarger = 2;
                }
            }
            if (abslarger == 3) return r;
            var t = abslarger == 1 ? a.slice() : b.slice();
            var u = abslarger == 1 ? b.slice() : a.slice();

            for (var i = N - 1; i >= 2; i--) {
                if (t[i] < u[i]) {
                    t[i - 1] -= 1;
                    t[i] += DIGIT;
                }
                r[i] = t[i] - u[i];
            }

            r[1] = t[1] - u[1];
            r[0] = abslarger == 1 ? a[0] : b[0];
        }
        return r;

    }

    var show = function (a) {
        var r = a[0] > 0 ? "" : "-";
        r += a[1] / DIGIT;
        for (var i = 2; i < N; i++) {
            r += a[i];
        }
        return r
    }

    return {
        num: num,
        mul: mul,
        plus: plus,
        show: show
    }

}();