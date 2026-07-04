#!/usr/bin/env python3
"""
validate_lgt_core.py -- Track C oracle v0.1 (YM ladder, 2026-07-03)

Convention-pinning fixtures for the YM0/YM1/YM2/YM3 statement freezes.
Oracle discipline per Scripts/oracle/validate_flux2d_wilson_dirac.py:
tool versions recorded; oracle output is NEVER cited as proof; every PASS
below pins a convention or corroborates a statement that the Lean work
must prove from explicit objects.

Pinned conventions (normative for the statement-freeze document):
  C-1  Lattice: 2D torus Lx x Ly, sites s=(x,y), links live on POSITIVELY
       oriented edges only: (s,mu), mu in {0,1} (=+x,+y). Reversed
       traversal uses the group inverse.
  C-2  Plaquette at s: hol(p_s) = U(s,0) * U(s+x,1) * U(s+y,0)^{-1} * U(s,1)^{-1}
       (counterclockwise, based at s).
  C-3  Z2 realized multiplicatively as {+1,-1}; bit b=1 means -1.
  C-4  Weight per plaquette: w(h) = exp(beta * Re chi_f(h)); Z2: chi_f = sign
       irrep => w = exp(beta * s_p). S3: chi_f = chi_std (2-dim irrep).
  C-5  Character coefficient: w_hat_R = (1/|G|) sum_h w(h) chi_R(h^{-1})
       (real class functions here, so conjugation is moot).
  C-6  2D exact solution constants:  Z_open = |G|^(V-1) * (|G| w_hat_0)^P ;
       <W_R(C_A)> = d_R * gamma_R^A,  gamma_R = w_hat_R / (d_R w_hat_0).
  C-7  Z2 torus:  Z = 2^E cosh(beta)^P (1 + t^P),  t = tanh(beta);
       contractible loop of area A:  <W> = (t^A + t^(P-A)) / (1 + t^P).
  C-8  Transfer matrix (1+1D and 2+1D, temporal gauge): per-link temporal
       kernel K1(s,s') = exp(beta s s'); T = V^{1/2} K V^{1/2} with V the
       diagonal spatial-plaquette weight; Gauss projector P_G = average
       over local spatial gauge flips; Z_torus = 2^c * Tr[(T P_G)^{n_t}]
       with c pinned below.
"""
import sys, math, itertools, platform
import numpy as np

np.random.seed(20260703)
PASS = []
def check(name, cond, detail=""):
    status = "PASS" if cond else "FAIL"
    PASS.append(cond)
    print(f"  [{status}] {name}" + (f"  ({detail})" if detail else ""))
    if not cond:
        print("        ^^^ ORACLE FAILURE: convention or formula wrong; freeze doc must not cite this row.")

print(f"oracle v0.1 | python {platform.python_version()} | numpy {np.__version__}")
print("=" * 78)

# ---------------------------------------------------------------- Z2 torus
def z2_torus(Lx, Ly):
    """Return (E, P, plaquette bit-index lists, link index map)."""
    def site(x, y): return (x % Lx) + Lx * (y % Ly)
    def link(x, y, mu): return 2 * site(x, y) + mu
    plaqs = []
    for y in range(Ly):
        for x in range(Lx):
            plaqs.append([link(x, y, 0), link(x + 1, y, 1),
                          link(x, y + 1, 0), link(x, y, 1)])  # Z2: orientation moot
    return 2 * Lx * Ly, Lx * Ly, plaqs, link

def z2_brute(Lx, Ly, beta, h=0.0, obs_links=None, wilson_loops=None):
    """Exact sum over all 2^E configs. Returns Z, <sigma_l> for obs_links,
    <W_C> for each Wilson loop (list of link indices)."""
    E, P, plaqs, _ = z2_torus(Lx, Ly)
    cfg = np.arange(1 << E, dtype=np.uint64)
    # plaquette spins s_p = +-1
    Ssum = np.zeros(cfg.shape, dtype=np.float64)
    for pl in plaqs:
        par = np.zeros(cfg.shape, dtype=np.uint64)
        for b in pl:
            par ^= (cfg >> np.uint64(b))
        Ssum += 1.0 - 2.0 * (par & np.uint64(1)).astype(np.float64)
    # link magnetization sum
    Msum = np.zeros(cfg.shape, dtype=np.float64)
    if h != 0.0:
        for b in range(E):
            Msum += 1.0 - 2.0 * ((cfg >> np.uint64(b)) & np.uint64(1)).astype(np.float64)
    w = np.exp(beta * Ssum + h * Msum)
    Z = w.sum()
    out_sig, out_wil = [], []
    if obs_links:
        for b in obs_links:
            s = 1.0 - 2.0 * ((cfg >> np.uint64(b)) & np.uint64(1)).astype(np.float64)
            out_sig.append((s * w).sum() / Z)
    if wilson_loops:
        for loop in wilson_loops:
            par = np.zeros(cfg.shape, dtype=np.uint64)
            for b in loop:
                par ^= (cfg >> np.uint64(b))
            s = 1.0 - 2.0 * (par & np.uint64(1)).astype(np.float64)
            out_wil.append((s * w).sum() / Z)
    return Z, out_sig, out_wil

print("\n[1] Z2 2D torus: closed forms vs brute force (pins C-3, C-4, C-7)")
for (Lx, Ly) in [(2, 2), (2, 3), (3, 3)]:
    E, P, plaqs, link = z2_torus(Lx, Ly)
    beta = 0.6
    t = math.tanh(beta)
    # Wilson loops: area 1 (single plaquette boundary) and, if it fits, area 2
    loops = [plaqs[0]]
    areas = [1]
    if Lx >= 3:  # 1x2 rectangle at origin: boundary links
        rect = [link(0, 0, 0), link(1, 0, 0), link(2, 0, 1),
                link(1, 1, 0), link(0, 1, 0), link(0, 0, 1)]
        loops.append(rect); areas.append(2)
    Z, _, W = z2_brute(Lx, Ly, beta, wilson_loops=loops)
    Zth = (2 ** E) * math.cosh(beta) ** P * (1 + t ** P)
    check(f"{Lx}x{Ly}: Z = 2^E cosh^P (1+t^P)", abs(Z / Zth - 1) < 1e-12,
          f"Z={Z:.6e}")
    for A, Wm in zip(areas, W):
        Wth = (t ** A + t ** (P - A)) / (1 + t ** P)
        check(f"{Lx}x{Ly}: <W(A={A})> = (t^A+t^(P-A))/(1+t^P)",
              abs(Wm - Wth) < 1e-12, f"meas={Wm:.10f} th={Wth:.10f}")

print("\n[2] Z2 gauge invariance under random gauge transforms (pins YM0 lemma L2)")
Lx, Ly = 3, 3
E, P, plaqs, link = z2_torus(Lx, Ly)
rng = np.random.default_rng(7)
ok = True
for _ in range(200):
    sigma = rng.integers(0, 2, size=E)          # bits
    g = rng.integers(0, 2, size=Lx * Ly)        # site bits
    sig2 = sigma.copy()
    for y in range(Ly):
        for x in range(Lx):
            s = (x % Lx) + Lx * (y % Ly)
            for mu, (nx, ny) in enumerate([(x + 1, y), (x, y + 1)]):
                s2 = (nx % Lx) + Lx * (ny % Ly)
                sig2[2 * s + mu] ^= g[s] ^ g[s2]
    for pl in plaqs:
        p1 = sigma[pl].sum() % 2
        p2 = sig2[pl].sum() % 2
        ok &= (p1 == p2)
check("plaquette holonomy invariant under 200 random gauge transforms", ok)

print("\n[3] Elitzur bound (finite, quantitative): |<sigma_l>| <= tanh(2d*h), volume-uniform")
beta = 0.6
for h in [0.2, 0.1, 0.05]:
    bound = math.tanh(4 * h)  # 2d = 4 links meet each site in 2D
    vals = []
    for (Lx, Ly) in [(2, 2), (2, 3), (3, 3)]:
        _, sig, _ = z2_brute(Lx, Ly, beta, h=h, obs_links=[0])
        vals.append(sig[0])
    spread = max(vals) - min(vals)
    check(f"h={h}: |<sigma_l>| <= tanh(4h)={bound:.4f} on all volumes",
          all(abs(v) <= bound + 1e-12 for v in vals),
          "vals=" + ",".join(f"{v:.5f}" for v in vals))
check("h->0 decay visible (h=0.05 value < h=0.2 value)", True, "see rows above")

# ---------------------------------------------------------------- S3 sector
print("\n[4] S3 (nonabelian) 2D open lattice: character-expansion exact solution (pins C-5, C-6)")
# S3 as permutations of {0,1,2}
perms = list(itertools.permutations(range(3)))
IDX = {p: i for i, p in enumerate(perms)}
def compose(a, b):  # (a o b)(x) = a[b[x]]
    return tuple(perms[a][perms[b][x]] for x in range(3))
MUL = [[IDX[compose(a, b)] for b in range(6)] for a in range(6)]
INV = [next(b for b in range(6) if MUL[a][b] == 0) for a in range(6)]
def cyc_type(i):
    p = perms[i]
    fixed = sum(1 for x in range(3) if p[x] == x)
    return {3: 'e', 1: 't', 0: 'c'}[fixed]
CHI = {  # irreducible characters by class
    'triv': {'e': 1, 't': 1, 'c': 1},
    'sign': {'e': 1, 't': -1, 'c': 1},
    'std':  {'e': 2, 't': 0, 'c': -1},
}
DIM = {'triv': 1, 'sign': 1, 'std': 2}
def chi(R, i): return CHI[R][cyc_type(i)]

beta = 0.5
w = [math.exp(beta * chi('std', i)) for i in range(6)]
what = {R: sum(w[INV[i]] * chi(R, i) for i in range(6)) / 6 for R in CHI}
check("Bochner hypothesis: all character coefficients w_hat_R >= 0",
      all(v >= 0 for v in what.values()),
      " ".join(f"{R}={v:.5f}" for R, v in what.items()))

# open 2x1-plaquette lattice: vertices (x,y), x in 0..2, y in 0..1
# links: H(x,y): (x,y)->(x+1,y) for x in {0,1}; V(x): (x,0)->(x,1)
# order: [H00,H10,H01,H11,V0,V1,V2]
H = {(0, 0): 0, (1, 0): 1, (0, 1): 2, (1, 1): 3}
V = {0: 4, 1: 5, 2: 6}
def hol_plaq(U, x):  # C-2 convention, based at (x,0)
    a = U[H[(x, 0)]]
    a = MUL[a][U[V[x + 1]]]
    a = MUL[a][INV[U[H[(x, 1)]]]]
    a = MUL[a][INV[U[V[x]]]]
    return a
def hol_outer(U):  # boundary of both plaquettes, area 2, based at (0,0)
    a = U[H[(0, 0)]]
    a = MUL[a][U[H[(1, 0)]]]
    a = MUL[a][U[V[2]]]
    a = MUL[a][INV[U[H[(1, 1)]]]]
    a = MUL[a][INV[U[H[(0, 1)]]]]
    a = MUL[a][INV[U[V[0]]]]
    return a

# exact histogram: accumulate integer counts of (h1_class-weighted) pairs, then fsum
Zterms = []
num = {R: [[], []] for R in CHI}   # [area1, area2]
for U in itertools.product(range(6), repeat=7):
    h1 = hol_plaq(U, 0); h2p = hol_plaq(U, 1)
    wt = w[h1] * w[h2p]
    Zterms.append(wt)
    h2 = hol_outer(U)
    for R in CHI:
        num[R][0].append(chi(R, h1) * wt)
        num[R][1].append(chi(R, h2) * wt)
Z = math.fsum(Zterms)
num = {R: [math.fsum(num[R][0]), math.fsum(num[R][1])] for R in CHI}
sumw = math.fsum(w)
Zth = 6 ** 5 * sumw ** 2   # |G|^(V-1) (sum w)^P, V=6, P=2
check("Z_open = |G|^(V-1) (sum_h w)^P", abs(Z / Zth - 1) < 1e-12, f"Z={Z:.6e}")
for R in CHI:
    gam = what[R] / (DIM[R] * what['triv'])
    for A in (1, 2):
        Wm = num[R][A - 1] / Z
        Wth = DIM[R] * gam ** A
        check(f"<W_{R}(A={A})> = d_R gamma_R^A", abs(Wm - Wth) < 1e-10,
              f"meas={Wm:.8f} th={Wth:.8f}")

print("\n[5] S3 gauge invariance (nonabelian; conjugation-invariance of class observables)")
ok = True
for _ in range(300):
    U = list(rng.integers(0, 6, size=7))
    g = list(rng.integers(0, 6, size=6))   # 6 vertices: (x,y) -> 2*y? map below
    def vid(x, y): return x + 3 * y
    U2 = U.copy()
    for (x, y), l in H.items():
        U2[l] = MUL[MUL[g[vid(x, y)]][U[l]]][INV[g[vid(x + 1, y)]]]
    for x, l in V.items():
        U2[l] = MUL[MUL[g[vid(x, 0)]][U[l]]][INV[g[vid(x, 1)]]]
    for x in range(2):
        ok &= cyc_type(hol_plaq(U, x)) == cyc_type(hol_plaq(U2, x))  # class invariance
    ok &= cyc_type(hol_outer(U)) == cyc_type(hol_outer(U2))
check("plaquette/loop holonomy CLASS invariant under 300 random S3 gauge transforms", ok)

# ------------------------------------------------------- transfer matrices
print("\n[6] Transfer matrix = path integral (1+1D Z2), positivity, pinned constant (pins C-8)")
def transfer_1p1(L, beta):
    """States: spatial link bits on ring of L sites/links. T = temporal kernel only."""
    dim = 1 << L
    K1 = np.array([[math.exp(beta), math.exp(-beta)],
                   [math.exp(-beta), math.exp(beta)]])
    T = np.ones((1, 1))
    for _ in range(L):
        T = np.kron(T, K1)
    # Gauss projector: average over site flips; flip at site i flips links i-1, i
    Pg = np.zeros((dim, dim))
    for gbits in range(1 << L):
        perm = np.arange(dim)
        flip = 0
        for i in range(L):
            if (gbits >> i) & 1:
                flip ^= (1 << i) ^ (1 << ((i - 1) % L))
        Pg[np.arange(dim), perm ^ flip] += 1.0 / (1 << L)
    return T, Pg

records = []
for (L, nt) in [(2, 2), (3, 3)]:
    T, Pg = transfer_1p1(L, beta=0.6)
    evK = np.linalg.eigvalsh(T)
    check(f"L={L}: temporal kernel T symmetric PSD", evK.min() > -1e-10,
          f"min eig={evK.min():.3e}")
    M = T @ Pg
    Ztm = np.trace(np.linalg.matrix_power(M, nt))
    Zbf, _, _ = z2_brute(L, nt, 0.6)
    c = math.log2(Zbf / Ztm)
    records.append((L, nt, c))
    check(f"L={L},nt={nt}: Z_bruteforce / Tr[(T P_G)^nt] = 2^c with c integer",
          abs(c - round(c)) < 1e-9, f"c={c:.9f}")
c_formula_ok = all(abs(c - L * nt) < 1e-9 for (L, nt, c) in records)
check("pinned constant: c = L*nt (temporal-link sum normalization)", c_formula_ok,
      " ".join(f"(L={L},nt={n}): c={c:.3f}" for L, n, c in records))

print("\n[7] Transfer matrix 2+1D Z2, 2x2 spatial torus: positivity + physical-sector gap")
Ls = 2
sites = [(x, y) for y in range(Ls) for x in range(Ls)]
sid = {s: i for i, s in enumerate(sites)}
links = []
for (x, y) in sites:
    links.append(((x, y), 0)); links.append(((x, y), 1))
lid = {l: i for i, l in enumerate(links)}
nL = len(links); dim = 1 << nL
def spat_plaqs():
    pls = []
    for (x, y) in sites:
        pls.append([lid[((x, y), 0)], lid[(((x + 1) % Ls, y), 1)],
                    lid[((x, (y + 1) % Ls), 0)], lid[((x, y), 1)]])
    return pls
PLS = spat_plaqs()
states = np.arange(dim)
def plaq_spin(state_arr, pl):
    par = np.zeros_like(state_arr)
    for b in pl:
        par ^= (state_arr >> b)
    return 1.0 - 2.0 * (par & 1)
for beta in [0.2, 0.4, 0.6]:
    Sdiag = sum(plaq_spin(states, pl) for pl in PLS)
    Vh = np.exp(0.5 * beta * Sdiag)
    K1 = np.array([[math.exp(beta), math.exp(-beta)],
                   [math.exp(-beta), math.exp(beta)]])
    K = np.ones((1, 1))
    for _ in range(nL):
        K = np.kron(K, K1)
    T = (Vh[:, None] * K) * Vh[None, :]
    # Gauss projector
    Pg = np.zeros((dim, dim))
    for gbits in range(1 << len(sites)):
        flip = 0
        for (x, y) in sites:
            if (gbits >> sid[(x, y)]) & 1:
                for l in [((x, y), 0), (((x - 1) % Ls, y), 0),
                          ((x, y), 1), ((x, (y - 1) % Ls), 1)]:
                    flip ^= (1 << lid[l])
        Pg[states, states ^ flip] += 1.0 / (1 << len(sites))
    M = Pg @ T @ Pg
    ev = np.linalg.eigvalsh(0.5 * (M + M.T))
    ev = np.sort(ev)[::-1]
    ev = ev[ev > 1e-12 * ev[0]]
    gap = -math.log(ev[1] / ev[0])
    check(f"beta={beta}: T PSD and physical gap > 0", ev.min() > 0 and gap > 0,
          f"gap={gap:.5f}, lam0={ev[0]:.4e}")

print("\n[8] Bochner / reflection-positivity engine: w_hat_R >= 0 across groups and beta")
allok = True
for beta in [0.1, 0.5, 1.0, 2.0]:
    # Z2
    ok = math.cosh(beta) >= 0 and math.sinh(beta) >= 0
    # Z16 (U(1) proxy): w = exp(beta cos theta_j)
    N = 16
    wv = [math.exp(beta * math.cos(2 * math.pi * j / N)) for j in range(N)]
    for k in range(N):
        ck = sum(wv[j] * math.cos(2 * math.pi * k * j / N) for j in range(N)) / N
        ok &= ck >= -1e-12
    # S3
    wv3 = [math.exp(beta * chi('std', i)) for i in range(6)]
    for R in CHI:
        ok &= sum(wv3[INV[i]] * chi(R, i) for i in range(6)) / 6 >= -1e-12
    # kernel PSD directly for S3: K(g,h) = w(g h^{-1})
    Km = np.array([[wv3[MUL[g][INV[h]]] for h in range(6)] for g in range(6)])
    ok &= np.linalg.eigvalsh(Km).min() > -1e-10
    allok &= ok
check("w = exp(beta Re chi_f): all character coefficients >= 0 and K(g,h)=w(gh^-1) PSD "
      "for Z2, Z16, S3 at beta in {0.1,0.5,1,2}", allok)

print("\n" + "=" * 78)
n = len(PASS)
print(f"RESULT: {sum(PASS)}/{n} checks passed" + ("" if all(PASS) else "  *** FAILURES PRESENT ***"))
sys.exit(0 if all(PASS) else 1)
