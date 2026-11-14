// 4K (only when asked): ?scale=2 makes the main canvas 2160x3840 while every drawing still uses 1080x1920 coordinates.
// Loaded by index.html before src/main.js. Patches only the main #cv context: setTransform/resetTransform keep the
// base scale, and blur(Npx) filters are scaled too. tools/capture.mjs passes scale (and res for the 3D engine).
(() => {
  const S = +(new URLSearchParams(location.search).get('scale') || 1);
  const cv = document.getElementById('cv');
  if (!cv || S === 1) return;
  cv.width = Math.round(cv.width * S); cv.height = Math.round(cv.height * S);
  const c = cv.getContext('2d'), P = CanvasRenderingContext2D.prototype;
  const st = P.setTransform, fd = Object.getOwnPropertyDescriptor(P, 'filter');
  c.setTransform = function (a, b, cc, d, e, f) {
    if (typeof a === 'object' && a) ({ a, b, c: cc, d, e, f } = a);
    if (a === undefined) return st.call(this, S, 0, 0, S, 0, 0);
    return st.call(this, a * S, b * S, cc * S, d * S, e * S, f * S);
  };
  c.resetTransform = function () { return st.call(this, S, 0, 0, S, 0, 0); };
  Object.defineProperty(c, 'filter', {
    get() { return fd.get.call(this); },
    set(v) { fd.set.call(this, String(v).replace(/(-?[\d.]+)px/g, (_, n) => `${+n * S}px`)); },
  });
  c.setTransform(1, 0, 0, 1, 0, 0);
})();
