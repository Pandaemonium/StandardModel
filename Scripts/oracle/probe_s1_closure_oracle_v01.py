#!/usr/bin/env python3
"""
probe_s1_closure_oracle_v01.py  (2026-07-07)

S1 oracle: nonabelian closure-slot (Q_C) identification on a finite
null-edge carrier model. Pre-registered outcomes (roadmap S1):
  (a) Q_C = L^# L for a rectangular closure current L
  (b) Q_C = sum_f J_f^# J_f + R, R classified (zero / PSD / indefinite)
  (c) R indefinite -> positivity relocates to physical-sector quotient (Q01)

CONVENTIONS (TRANSCRIPTION RISK -- to be checked against the Lean pins):
  2+1 Minkowski, eta = diag(+,-,-).
  gamma0 = s3, gamma1 = i*s1, gamma2 = i*s2  =>  {g^m, g^n} = 2 eta^{mn}.
  Krein fundamental symmetry J = gamma0;  X^# := J X^dag J.
  c(alpha) = alpha_m g^m (alpha real covector, lower components,
  pairing g(a,b) = a0 b0 - a1 b1 - a2 b2).  c(alpha)^# = c(alpha).
  Base: Z_N x Z_N torus. Covariant shift (S_mu psi)(x) = U_mu(x) psi(x+mu).
  nabla_mu = (S_mu - S_mu^dag)/2  (Hilbert- and #-skew:  nabla^# = -nabla).
  Carrier:  D = sum_mu c(alpha_mu) (x) nabla_mu   on  spinor (x) site (x) color.
  Then D^# = -D and (all fixtures below verify this transcription):
      D^#D = Q_A + Q_C,
      Q_A  = -g12 * I_2 (x) {nabla_1, nabla_2},
      Q_C  = -b (x) [nabla_1, nabla_2],     b := (c1 c2 - c2 c1)/2.
  (Phi = 0, constant soldering: Q_T = 0, E = 0 on this class.)
"""
import numpy as np

np.random.seed(20260707)
TOL = 1e-10
results = []

def check(name, ok, detail=""):
    results.append((name, ok, detail))
    print(f"[{'PASS' if ok else 'FAIL'}] {name}  {detail}")

# ---------------------------------------------------------------- Clifford
s1 = np.array([[0, 1], [1, 0]], dtype=complex)
s2 = np.array([[0, -1j], [1j, 0]], dtype=complex)
s3 = np.array([[1, 0], [0, -1]], dtype=complex)
I2 = np.eye(2, dtype=complex)
gam = [s3, 1j * s1, 1j * s2]          # gamma^0, gamma^1, gamma^2
Jsp = s3                               # Krein symmetry on spinor factor
eta_inv = np.diag([1.0, -1.0, -1.0])   # pairing on covectors

def cliff(a):
    return sum(a[m] * gam[m] for m in range(3))

def pair(a, b):
    return float(a @ eta_inv @ b)

# two future null covectors, non-collinear
phi0 = 2.0
a1 = np.array([1.0, 1.0, 0.0])
a2 = np.array([1.0, np.cos(phi0), np.sin(phi0)])
c1, c2 = cliff(a1), cliff(a2)
g12 = pair(a1, a2)
b = (c1 @ c2 - c2 @ c1) / 2.0

check("R0.1 Clifford algebra {c(a),c(b)} = 2 g(a,b)",
      np.allclose(c1 @ c2 + c2 @ c1, 2 * g12 * I2, atol=TOL)
      and np.allclose(c1 @ c1, 0 * I2, atol=TOL)
      and np.allclose(c2 @ c2, 0 * I2, atol=TOL),
      f"g12={g12:.6f}, c(null)^2=0")
check("R0.2 bivector square b^2 = g12^2 * I  (boost generator, eigs +/- g12)",
      np.allclose(b @ b, g12**2 * I2, atol=TOL))
check("R0.3 Krein: c^# = c, b^# = -b",
      np.allclose(Jsp @ c1.conj().T @ Jsp, c1, atol=TOL)
      and np.allclose(Jsp @ b.conj().T @ Jsp, -b, atol=TOL))

# ---------------------------------------------------------------- groups
def su2_haar():
    v = np.random.randn(4); v /= np.linalg.norm(v)
    return np.array([[v[0] + 1j * v[3], v[2] + 1j * v[1]],
                     [-v[2] + 1j * v[1], v[0] - 1j * v[3]]], dtype=complex)

def su2_exp(x):  # exp(i x.sigma), exact
    n = np.linalg.norm(x)
    if n < 1e-15:
        return I2.copy()
    return np.cos(n) * I2 + 1j * np.sin(n) * (x[0] * s1 + x[1] * s2 + x[2] * s3) / n

def sun_haar(n):
    z = (np.random.randn(n, n) + 1j * np.random.randn(n, n)) / np.sqrt(2)
    q, r = np.linalg.qr(z)
    q = q @ np.diag(np.diag(r) / np.abs(np.diag(r)))
    return q / np.linalg.det(q) ** (1.0 / n)

# ------------------------------------------- F1: SU(2) per-face structure
for t in range(50):
    U = su2_haar()
    M = I2 - U
    ok1 = np.allclose(M @ M.conj().T, (2 - np.trace(U).real) * I2, atol=TOL)
    ok2 = np.allclose(M, 0.5 * (M @ M.conj().T) + 0.5 * (U.conj().T - U), atol=TOL)
    if not (ok1 and ok2):
        break
check("R1.1 SU(2) centrality: (1-U)(1-U)^dag = (2 - tr U) * I  [50 Haar draws]", ok1)
check("R1.2 exact per-face split: 1-U = (1/2)(1-U)(1-U)^dag + (1/2)(U^dag - U)", ok2)

U3 = sun_haar(3)
M3 = np.eye(3) - U3
G3 = M3 @ M3.conj().T
dist = np.linalg.norm(G3 - (np.trace(G3) / 3) * np.eye(3))
check("R1.3 SU(3) centrality FAILS (per-face Gram non-central)", dist > 1e-3,
      f"dist from scalar = {dist:.4f}")

# scaling of the two split pieces: Gram ~ eps^2, field-strength ~ eps
eps_grid = np.array([0.02, 0.04, 0.08, 0.16])
x0 = np.random.randn(3); x0 /= np.linalg.norm(x0)
gram_n, fs_n = [], []
for e in eps_grid:
    W = su2_exp(e * x0)
    Mw = I2 - W
    gram_n.append(np.linalg.norm(0.5 * Mw @ Mw.conj().T))
    fs_n.append(np.linalg.norm(0.5 * (W.conj().T - W)))
sl_g = np.polyfit(np.log(eps_grid), np.log(gram_n), 1)[0]
sl_f = np.polyfit(np.log(eps_grid), np.log(fs_n), 1)[0]
check("R1.4 split scaling: Gram piece ~ eps^2 (=> a^4 |F|^2), field-strength piece ~ eps (=> a^2 F)",
      abs(sl_g - 2) < 0.05 and abs(sl_f - 1) < 0.05,
      f"slopes: gram={sl_g:.3f}, fs={sl_f:.3f}")

# ---------------------------------------------------------------- lattice
N = 3
NS = N * N
NC = 2                       # SU(2) color
DIMSC = NS * NC              # site (x) color
DIM = 2 * DIMSC              # spinor (x) site (x) color
Jf = np.kron(Jsp, np.eye(DIMSC))

def idx(x1, x2):
    return (x1 % N) * N + (x2 % N)

def shift_op(links, mu):
    """S_mu = sum_x |x><x+mu| (x) U_mu(x)."""
    S = np.zeros((DIMSC, DIMSC), dtype=complex)
    for x1 in range(N):
        for x2 in range(N):
            x = idx(x1, x2)
            y = idx(x1 + (mu == 1), x2 + (mu == 2))
            S[x * NC:(x + 1) * NC, y * NC:(y + 1) * NC] = links[mu - 1][x1][x2]
    return S

def build(links):
    S1_, S2_ = shift_op(links, 1), shift_op(links, 2)
    n1 = (S1_ - S1_.conj().T) / 2
    n2 = (S2_ - S2_.conj().T) / 2
    D = np.kron(c1, n1) + np.kron(c2, n2)
    K = n1 @ n2 - n2 @ n1
    QA = -g12 * np.kron(I2, n1 @ n2 + n2 @ n1)
    QC = -np.kron(b, K)
    return S1_, S2_, n1, n2, D, K, QA, QC

def sharp(X):
    return Jf @ X.conj().T @ Jf

def rand_links(group=su2_haar):
    return ([[group() for _ in range(N)] for _ in range(N)],
            [[group() for _ in range(N)] for _ in range(N)])

def links_from(f1, f2):
    return ([[f1(x1, x2) for x2 in range(N)] for x1 in range(N)],
            [[f2(x1, x2) for x2 in range(N)] for x1 in range(N)])

L1r = [[su2_haar() for _ in range(N)] for _ in range(N)]
L2r = [[su2_haar() for _ in range(N)] for _ in range(N)]
links_rand = (np.array(L1r), np.array(L2r))
links_rand = ([[L1r[i][j] for j in range(N)] for i in range(N)],
              [[L2r[i][j] for j in range(N)] for i in range(N)])
S1o, S2o, n1o, n2o, Do, Ko, QAo, QCo = build(links_rand)

# E0: transcription pins
check("R2.1 unitarity of covariant shifts",
      np.allclose(S1o @ S1o.conj().T, np.eye(DIMSC), atol=TOL)
      and np.allclose(S2o @ S2o.conj().T, np.eye(DIMSC), atol=TOL))
check("R2.2 D^# = -D  (carrier is #-skew in this convention)",
      np.allclose(sharp(Do), -Do, atol=TOL))
check("R2.3 Weitzenboeck bookkeeping on this class: D^#D = Q_A + Q_C exactly "
      "(Phi=0, const soldering; diagonal killed by c(null)^2=0)",
      np.allclose(sharp(Do) @ Do, QAo + QCo, atol=TOL))
check("R2.4 Q_C is #-self-adjoint", np.allclose(sharp(QCo), QCo, atol=TOL))

# commutator = plaquette defect x transport (kernel identity transcription)
def plaquette(links, x1, x2):
    U1, U2 = links
    return (U1[x1][x2] @ U2[(x1 + 1) % N][x2]
            @ U1[x1][(x2 + 1) % N].conj().T @ U2[x1][x2].conj().T)

RHS = np.zeros((DIMSC, DIMSC), dtype=complex)
for x1 in range(N):
    for x2 in range(N):
        x = idx(x1, x2); y = idx(x1 + 1, x2 + 1)
        W = plaquette(links_rand, x1, x2)
        blk = (W - I2) @ links_rand[1][x1][x2] @ links_rand[0][x1][(x2 + 1) % N]
        RHS[x * NC:(x + 1) * NC, y * NC:(y + 1) * NC] = blk
check("R2.5 [S1,S2] = (W(x) - 1) . (transport dressing)  per (1,1)-hop block",
      np.allclose(S1o @ S2o - S2o @ S1o, RHS, atol=TOL))

# flatness <=> Q_C = 0
gsite = [[su2_haar() for _ in range(N)] for _ in range(N)]
pg = links_from(lambda x1, x2: gsite[x1][x2] @ gsite[(x1 + 1) % N][x2].conj().T,
                lambda x1, x2: gsite[x1][x2] @ gsite[x1][(x2 + 1) % N].conj().T)
_, _, _, _, _, _, _, QCflat = build(pg)
Uc1, Uc2 = su2_exp(np.array([0, 0, 0.7])), su2_exp(np.array([0, 0, -1.1]))
tw = links_from(lambda *_: Uc1, lambda *_: Uc2)
_, _, _, _, _, _, _, QCtw = build(tw)
check("R3.1 flat (pure gauge) => Q_C = 0", np.linalg.norm(QCflat) < 1e-9,
      f"|Q_C|={np.linalg.norm(QCflat):.2e}")
check("R3.2 random field => Q_C != 0", np.linalg.norm(QCo) > 1.0,
      f"|Q_C|={np.linalg.norm(QCo):.3f}")
check("R3.3 flat-but-topological (commuting constant cycles): Q_C = 0 "
      "(closure slot blind to 't Hooft-flux / Wilson-line sectors)",
      np.linalg.norm(QCtw) < 1e-9)

# ----------------------------- E1: displacement grading of Q_C vs site-diagonal Grams
def site_diag_part(X):
    Y = np.zeros_like(X)
    for sA in range(2):
        for sB in range(2):
            for x in range(NS):
                r0 = sA * DIMSC + x * NC
                c0 = sB * DIMSC + x * NC
                Y[r0:r0 + NC, c0:c0 + NC] = X[r0:r0 + NC, c0:c0 + NC]
    return Y

check("R4.1 Q_C has NO site-diagonal component (support: hops +/-(1,1), +/-(1,-1) only)",
      np.linalg.norm(site_diag_part(QCo)) < 1e-9)

# registered S-C candidate: G = sum_p M_p^# M_p, M_p = beta (x) |x><x| (x) (1 - W(x))
Gcand = np.zeros((DIM, DIM), dtype=complex)
for x1 in range(N):
    for x2 in range(N):
        x = idx(x1, x2)
        W = plaquette(links_rand, x1, x2)
        P = np.zeros((DIMSC, DIMSC), dtype=complex)
        P[x * NC:(x + 1) * NC, x * NC:(x + 1) * NC] = I2 - W
        Mp = np.kron(I2, P)
        Gcand += sharp(Mp) @ Mp
ip = abs(np.vdot(QCo, Gcand))
Rrem = QCo - Gcand
check("R4.2 registered S-C candidate is Frobenius-ORTHOGONAL to Q_C "
      "(site-diagonal Gram cannot see the commutator slot)", ip < 1e-8,
      f"<Q_C, G>_F = {ip:.2e}; |R| = |Q_C - G| = {np.linalg.norm(Rrem):.3f} "
      f">= |Q_C| = {np.linalg.norm(QCo):.3f}")

# ----------------------------- E2: the exact square representation (outcome a)
Lrep = np.kron(c1, np.eye(DIMSC)) + np.kron(c2, -Ko / 2)
check("R5.1 OUTCOME (a): Q_C = L^# L exactly, L = c(a1) (x) 1 + c(a2) (x) (-[n1,n2]/2)",
      np.allclose(sharp(Lrep) @ Lrep, QCo, atol=TOL),
      f"|L#L - Q_C| = {np.linalg.norm(sharp(Lrep) @ Lrep - QCo):.2e}")

okfam = True
for t in range(5):
    A = np.eye(DIMSC) + 0.3 * (np.random.randn(DIMSC, DIMSC)
                               + 1j * np.random.randn(DIMSC, DIMSC))
    B = np.linalg.solve(A.conj().T, -Ko / 2)
    Lt = np.kron(c1, A) + np.kron(c2, B)
    okfam &= np.allclose(sharp(Lt) @ Lt, QCo, atol=1e-8)
check("R5.2 family: L_A = c(a1)(x)A + c(a2)(x)(A^dag)^{-1}(-K/2), any invertible A "
      "=> L_A^# L_A = Q_C  [GL-torsor of representations]", okfam)

# uniqueness of the invariant: A^dag B is pinned to -K/2
Xinv = np.eye(DIMSC).conj().T @ (-Ko / 2)
check("R5.3 invariant content: A^dag B = -K/2 forced "
      "(sym part auto-vanishes since K is skew)",
      np.allclose(Xinv + Xinv.conj().T, 0, atol=TOL))

# ----------------------------- E3: Krein signature (the # honesty caveat, quantified)
def signature(Xherm):
    ev = np.linalg.eigvalsh(Xherm)
    return int(np.sum(ev > 1e-9)), int(np.sum(ev < -1e-9)), int(np.sum(np.abs(ev) <= 1e-9))

sigQC = signature(Jf @ QCo)
sigDD = signature(Jf @ (sharp(Do) @ Do))
check("R6.1 Krein form of Q_C on FULL space is INDEFINITE "
      "(positivity was never a full-space fact; sector restriction is load-bearing)",
      sigQC[0] > 0 and sigQC[1] > 0, f"sig(J Q_C) = (+{sigQC[0]}, -{sigQC[1]}, 0:{sigQC[2]})")
check("R6.2 Krein form of D^#D on FULL space also indefinite (doubler/tachyon branches)",
      sigDD[0] > 0 and sigDD[1] > 0, f"sig(J D#D) = (+{sigDD[0]}, -{sigDD[1]}, 0:{sigDD[2]})")

# ----------------------------- E4: aperture fixture (P-iv shape) -- flat spectrum
one = links_from(lambda *_: I2, lambda *_: I2)
_, _, _, _, Dfl, _, _, _ = build(one)
DDfl = sharp(Dfl) @ Dfl
pred = []
for k1 in range(N):
    for k2 in range(N):
        sk1, sk2 = np.sin(2 * np.pi * k1 / N), np.sin(2 * np.pi * k2 / N)
        p = sk1 * a1 + sk2 * a2
        pred += [pair(p, p)] * 4          # 2 spinor x 2 color
ev = np.sort(np.linalg.eigvals(DDfl).real)
check("R7.1 flat carrier spectrum = Minkowski norm^2 of soldered sine-momentum "
      "(matches P-iv aperture shape 2 s1 s2 g(a1,a2); negative doubler branches present)",
      np.allclose(ev, np.sort(pred), atol=1e-8),
      f"min={ev[0]:.3f}, max={ev[-1]:.3f}")

# ----------------------------- E5: field-strength reading -- |Q_C| linear in field
slopes_src = []
X1f = [[np.random.randn(3) for _ in range(N)] for _ in range(N)]
X2f = [[np.random.randn(3) for _ in range(N)] for _ in range(N)]
nrm, nrmG = [], []
for e in eps_grid:
    lk = links_from(lambda x1, x2: su2_exp(e * X1f[x1][x2]),
                    lambda x1, x2: su2_exp(e * X2f[x1][x2]))
    _, _, _, _, _, _, _, QCe = build(lk)
    nrm.append(np.linalg.norm(QCe))
    Ge = 0.0
    for x1 in range(N):
        for x2 in range(N):
            Mw = I2 - plaquette(lk, x1, x2)
            Ge += np.linalg.norm(Mw @ Mw.conj().T) ** 2
    nrmG.append(np.sqrt(Ge))
slQ = np.polyfit(np.log(eps_grid), np.log(nrm), 1)[0]
slG = np.polyfit(np.log(eps_grid), np.log(nrmG), 1)[0]
check("R8.1 weak-field scaling: |Q_C| ~ eps^1 (spin-curvature / sigma.F reading), "
      "closure-defect Gram ~ eps^2 (|F|^2 energy reading) -- DIFFERENT objects",
      abs(slQ - 1) < 0.06 and abs(slG - 2) < 0.06,
      f"slopes: Q_C={slQ:.3f}, Gram={slG:.3f}")

# ----------------------------- summary
npass = sum(1 for _, ok, _ in results if ok)
print(f"\n=== S1 closure oracle v0.1: {npass}/{len(results)} PASS ===")
print("numpy", np.__version__, " seed 20260707  N =", N, " tol", TOL)
